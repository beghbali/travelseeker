class Clip < ActiveRecord::Base

  attr_accessor :metadata

  scope :yelp, -> { where("uri like '%yelp.com%") }
  scope :tripadvisor, -> { where("uri like '%tripadvisor.com%") }

  delegate :latitude, :longitude, :name, to: :metadata, allow_nil: true

  def yelp?
    uri =~ /yelp\.com/
  end

  def tripadvisor?
    uri =~ /tripadvisor\.com/
  end

  def yelp_business_id
    YelpMetaData.business_id_from_url(uri)
  end

  def metadata
    @metadata ||= (yelp? ? YelpMetaData.new(yelp_business_id) : nil) #this needs to support tripadvisor and others
  end

end
