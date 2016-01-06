class Clip < ActiveRecord::Base
  acts_as_taggable_on :type, :days, :dates
  acts_as_commentable

  attr_accessor :metadata, :near

  has_one :comment, as: :commentable
  belongs_to :trip

  accepts_nested_attributes_for :comment

  before_save :set_reference
  before_save :set_location

  scope :yelp, -> { where("uri like '%yelp.com%") }
  scope :tripadvisor, -> { where("uri like '%tripadvisor.com%") }
  scope :for_session, ->(session_id) { where(session_id: session_id).order(created_at: :desc)}
  scope :known_location, -> { where('latitude IS NOT NULL') }

  delegate :name, :address, :external_reference, :url, :rating_image_url, :phone, :hours, :image_url, to: :metadata, allow_nil: true

  def self.last_clip_location_for_session(session_id)
    Rails.cache.fetch(['last_clip_location', session_id, Clip.for_session(session_id).known_location.count]) do
      Clip.for_session(session_id).known_location.first.try(:location)
    end
  end

  def self.available_tags_for(session_id, type="tag")
    for_session(session_id).map(&:"#{type}_list").flatten.uniq
  end

  def available_type_tags
    %w(Food Activity Lodging)
  end

  def available_day_tags
    trip.dates.map{|day| "Day #{day}"} unless trip.dates_known?
  end

  def available_date_tags
    trip.dates.map{|date| date.strftime("%B %d #{date.day.ordinalize}")}
  end

  def comment_attributes=(attrs)
    comment.try(:delete)
    super
  end

  def date=(date)
    date_list.add date.strftime("%B %d #{date.day.ordinalize}") unless date.blank?
  end

  def day=(day)
    day_list.add "Day #{day}"
  end

  def set_reference
    self.reference = external_reference
  end

  def latitude
    self[:latitude] || metadata.latitude
  end

  def longitude
    self[:longitude] || metadata.longitude
  end

  def location
    Location.new(self.slice(*%i(latitude longitude)).symbolize_keys)
  end

  def set_location
    self.latitude = latitude
    self.longitude = longitude
  end

  def yelp?
    !!(uri =~ /yelp\.com/)
  end

  def tripadvisor?
    !!(uri =~ /tripadvisor\.com/)
  end

  def yelp_business_id
    YelpMetaData.business_id_from_url(uri)
  end

  def tripadvisor_business_id
    TripadvisorMetaData.business_id_from_url(uri)
  end

  def yelp
    @yelp ||= YelpMetaData.new(yelp_business_id)
  end

  def tripadvisor
    @tripadvisor ||= TripadvisorMetaData.new(tripadvisor_business_id)
  end

  def google_places
    @google_places ||= GooglePlacesMetaData.new(uri, near, reference)
  end

  def source
    if yelp?
      "Yelp"
    elsif tripadvisor?
      "TripAdvisor"
    else
      "Google Places"
    end
  end

  def metadata
    @metadata ||=
      if yelp?
        yelp
      elsif tripadvisor?
        tripadvisor
      else
        google_places
      end
  rescue GooglePlacesMetaData::NoGooglePlacesRecordFoundError
    Rails.logger.warn "No spots found. failed for terms #{uri}"
    nil
  end

end
