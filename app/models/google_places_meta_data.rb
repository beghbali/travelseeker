class GooglePlacesMetaData < MetaData
  class NoGooglePlacesRecordFoundError < StandardError; end

  attr_accessor :google_places_data, :client, :location, :terms, :reference

  delegate :name, :region, :country, to: :google_places_data, allow_nil: true
  alias_method :state, :region

  def initialize(terms, location=nil, reference=nil)
    super()
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    @location = location
    @terms = terms
    @reference = reference
  end

  def data_cache_key
    ['google-places', terms, reference]
  end

  def google_places_data
    @google_places_data ||= begin
      Rails.cache.fetch(data_cache_key, expires_in: 1.day) do
        return no_spots_found if terms.blank?
        response = query_by_reference || first_location_search_result || first_terms_search_result
        puts ">>QUERY: #{terms}"
        puts response.inspect
        response.present? ? response : no_spots_found
      end
    end
  rescue GooglePlaces::OverQueryLimitError
    Rails.logger.warn "Over quota for google places. failed for terms #{terms}"
  rescue GooglePlacesMetaData::NoGooglePlacesRecordFoundError
    Rails.logger.warn "No spots found. failed for terms #{terms}"
  rescue GooglePlaces::InvalidRequestError
    Rails.logger.warn "Invalid request: #{terms}, #{location.inspect}"
  ensure
    @google_places_data ||= NullObject.new
    return @google_places_data
  end

  private def no_spots_found
    Rails.logger.warn "No spots found. failed for terms #{terms}"
    NullObject.new
  end

  def has_any_data?
    google_places_data.class != NullObject
  end

  def latitude
    google_places_data.lat
  end

  def longitude
    google_places_data.lng
  end

  def url
    google_places_data.url || google_search_url
  end

  def google_search_url
    URI::HTTPS.build(host: "www.google.com", path: "/search", query: {q: terms}.to_query).to_s
  end

  def address
    google_places_data.formatted_address || google_places_data.address_components.map{|c| c['long_name']}.join(" ")
  end

  def type
    if (google_places_data.types & ["restaurant", "food", "bar"]).length > 0
      "Food"
    elsif (google_places_data.types & ["airport", "train_station", "transit_station"]).length > 0
      "Transit"
    elsif (google_places_data.types & ["point_of_interest"]).length > 0
      "Activity"
    end
  end

  def city
    begin
      if google_places_data.city.present?
        google_places_data.city
      else
        data = google_places_data.address_components && google_places_data.address_components.detect{|c| c['types'].include? 'locality'}
        data.present? ? data['long_name'] : address_components[-2]
      end
    end.try(:strip)
  end

  def address_components
    google_places_data.formatted_address.present? ? google_places_data.formatted_address.split(',') : []
  end

  def image_url
    google_places_data.presence && google_places_data.photos[0].try(:fetch_url, 300) rescue nil
  end

  def external_reference
    google_places_data.place_id
  end

  def phone
    google_places_data.international_phone_number
  end

  def hours
    google_places_data.opening_hours && google_places_data.opening_hours['weekday_text'].join("\n")
  end

  private def query_by_reference
    reference && client.spot(reference)
  end

  private def query_by_location
    client.spots_by_query(terms, lat: location.try(:latitude), long: location.try(:longitude), radius: 50000)
  end

  private def query_by_terms
    client.spots_by_query(terms, radius: 50000)
  end

  private def first_location_search_result
    self.reference = (location && query_by_location.first.place_id)
    query_by_reference
  end

  private def first_terms_search_result
    self.reference =  query_by_terms.first.try(:place_id)
    query_by_reference
  end
end