class YelpMetaData < MetaData

  attr_accessor :yelp_data, :business_id
  alias_method :data, :yelp_data

  def self.business_id_from_url(url)
    url.split('/').last.try(:split, '?').try(:first)
  end

  def initialize(business_id)
    super()
    @business_id = business_id
  end

  def yelp_data
    @yelp_data ||= Yelp.client.business(business_id).try(:business)
  end

  def latitude
    yelp_data.location.coordinate.latitude
  end

  def longitude
    yelp_data.location.coordinate.longitude
  end

  delegate :name, :image_url, :url, :phone, to: :yelp_data

  def address
    yelp_data.location.display_address.join(" ")
  end

  def reference
    yelp_data.id
  end

  def rating_image_url
    yelp_data.instance_variable_get("@rating_img_url")
  end

end