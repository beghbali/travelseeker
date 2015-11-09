class YelpMetaData < MetaData

  attr_accessor :yelp_data

  def self.business_id_from_url(url)
    url.split('/').last.try(:split, '?').try(:first)
  end

  def initialize(business_id)
    super()
    self.yelp_data = Yelp.client.business(business_id).try(:business)
  end

  def latitude
    yelp_data.location.coordinate.latitude
  end

  def longitude
    yelp_data.location.coordinate.longitude
  end

  delegate :name, to: :yelp_data
end