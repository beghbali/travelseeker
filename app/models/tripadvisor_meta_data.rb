class TripadvisorMetaData < MetaData

  attr_accessor :tripadvisor_data

  def self.business_id_from_url(url)
    url.split('-').detect{|segment| segment =~ /^d\d+$/}[1..-1]
  end

  def initialize(business_id)
    super()
    client = TripAdvisor::API.new(base_url: 'https://api.tripadvisor.com/api/partner/2.0/', api_key: ENV['TRIPADVISOR_API_KEY'])
    response = client.get("location/#{business_id}")
    self.tripadvisor_data = Hashie::Mash.new(JSON.parse response)
  end

  def latitude
    tripadvisor_data.latitude
  end

  def longitude
    tripadvisor_data.longitude
  end

  delegate :name, to: :tripadvisor_data
end