class GooglePlacesMetaData < MetaData
  class NoGooglePlacesRecordFoundError < StandardError; end

  attr_accessor :google_places_data, :client, :location, :terms

  def initialize(terms, location=nil)
    super()
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    @location = location
    @terms = terms
  end

  def google_places_data
    @google_places_data ||= begin
      Rails.cache.fetch(['google-places', terms, location], 1.day) do
        response = client.spots_by_query(terms, lat: location.try(:latitude), long: location.try(:longitude)).first
        raise NoGooglePlacesRecordFoundError unless response.present?
      end
    end
  rescue GooglePlaces::OverQueryLimitError
    Rails.logger.warn "Over quota for google places. failed for terms #{terms}"
  rescue GooglePlacesMetaData::NoGooglePlacesRecordFoundError
    Rails.logger.warn "No spots found. failed for terms #{terms}"
  ensure
    @google_places_data = NullObject.new
    return @google_places_data
  end

  def latitude
    google_places_data.lat
  end

  def longitude
    google_places_data.lng
  end

  delegate :name, to: :google_places_data

  def url
    google_places_data.url || google_search_url
  end

  def google_search_url
    URI::HTTPS.build(host: "www.google.com", path: "/search", query: {q: terms}.to_query).to_s
  end

  def address
    google_places_data.formatted_address || google_places_data.address_components.try(:join, " ")
  end

  def spot
    return nil unless google_places_data.present?
    @spot ||= client.spot(reference)
  end

  def image_url
    spot.presence && spot.photos[0].try(:fetch_url, 100)
  end

  def reference
    google_places_data.place_id
  end

  def phone
    google_places_data.phone
  end

  def hours
    google_places_data.weekday_text
  end
end