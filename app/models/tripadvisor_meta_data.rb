class TripadvisorMetaData < MetaData

  attr_accessor :tripadvisor_data, :client, :business_id

  alias_method :data, :tripadvisor_data

  delegate :address, :city, :state, :country, to: :address_obj, allow_nil: true

  def self.business_id_from_url(url)
    url.split('-').detect{|segment| segment =~ /^d\d+$/}[1..-1]
  end

  def initialize(business_id)
    super()
    @client = TripAdvisor::API.new(base_url: 'https://api.tripadvisor.com/api/partner/2.0/', api_key: ENV['TRIPADVISOR_API_KEY'])
    @business_id = business_id
  end

  def tripadvisor_data
    @tripadvisor_data ||= begin
      response = client.get("location/#{business_id}")
      Hashie::Mash.new(JSON.parse response)
    end
  rescue RestClient::ResourceNotFound
    Rails.logger.warn "TripAdvisor did not find #{business_id}"
    @tripadvisor_data = NullObject.new
    return @tripadvisor_data
  end

  def latitude
    tripadvisor_data.latitude
  end

  def longitude
    tripadvisor_data.longitude
  end

  delegate :name, :rating_image_url, to: :tripadvisor_data

  def image_url
    nil
  end

  def address_obj
    @address_obj ||= tripadvisor_data.address_obj
  end

  def city

  def external_reference
    tripadvisor_data.location_id
  end

  def url
    tripadvisor_data.web_url
  end

end