class Clip < ActiveRecord::Base
  acts_as_taggable_on :type, :days, :dates
  acts_as_commentable

  attr_accessor :metadata, :near

  has_one :comment, as: :commentable
  belongs_to :trip

  accepts_nested_attributes_for :comment

  TYPES = %w(Food Activity Lodging Transit Unassigned)
  validates :reference, uniqueness: { scope: :trip_id }
  validates :uri, uniqueness: { scope: :trip_id }
  before_validation :set_reference, if: -> { reference.nil? }
  before_save :set_location
  before_save :reassociate_annotated_weblinks, if: :persisted?
  before_save :ensure_tagged
  before_create :create_and_assign_to_new_trip

  after_destroy :remove_orphaned_trip

  scope :yelp, -> { where("uri like '%yelp.com%") }
  scope :tripadvisor, -> { where("uri like '%tripadvisor.com%") }
  scope :for_session, ->(session_id) { where(session_id: session_id).order(created_at: :desc)}
  scope :known_location, -> { where('latitude IS NOT NULL') }

  delegate :city, :state, :country, :external_reference, :url, :rating_image_url, :phone, :hours, :image_url, to: :metadata, allow_nil: true

  validates :uri, presence: true

  def self.last_clip_location_for_session(session_id)
    Rails.cache.fetch(['last_clip_location', session_id, Clip.for_session(session_id).known_location.count]) do
      Clip.for_session(session_id).known_location.first.try(:location)
    end
  end

  def self.available_tags_for(session_id, type="tag")
    for_session(session_id).map(&:"#{type}_list").flatten.uniq
  end

  TYPES.each do |type|
    define_method "#{type.downcase}?" do
      type_list.include? type
    end
  end

  def ancestor
    parent = trip
    while parent.parent.present?
      parent = parent.parent
    end
    parent
  end

  def address
    self[:address].presence || metadata.address
  end

  def user_provided_name
    self[:name] || uri
  end

  def name
    self[:name].presence || metadata.name || self.uri
  end

  def name=(new_name)
    super
    self.reference = nil
    self[:address] = nil
  end

  def scheduled?
    scheduled_at.present?
  end

  def scheduled_at=(date_or_string)
    self[:scheduled_at] = date_or_string.try(:to_datetime).try(:change, offset: 0)
    remove_unassigned_tag if self[:scheduled_at].present?
  end

  def scheduled_day
    scheduled_at.try(:to_date)
  end

  def scheduled_time
    scheduled_at.try(:strftime, "%I:%M %P")
  end

  def remove_orphaned_trip
    trip.destroy unless trip.clips.any? || trip.trips.any?
  end

  def remove_unassigned_tag
    day_list.remove 'Unassigned'
  end

  def available_type_tags
    TYPES
  end

  def available_day_tags
    trip.dates.map{|day| "Day #{day}"} unless trip.dates_known?
  end

  def available_date_tags
    trip.dates.map{|date| date.strftime("%B #{date.day.ordinalize}")}
  end

  def same_location_as(obj_with_country)
    ISO3166::Country.find_by_name(self.country) == ISO3166::Country.find_by_name(obj_with_country.country)
  end

  def reassociate_annotated_weblinks
    if trip.city != self.city
      create_and_assign_to_new_trip(trip.parent)
    end
  end

  def existing_city_trip(in_trip)
    in_trip.trips.in_city(city).first
  end

  def create_and_assign_to_new_trip(in_trip=self.trip)
    designated_trip = existing_city_trip(in_trip) ||
      in_trip.trips.create!(location: city, latitude: latitude, longitude: longitude,
        session_id: session_id, user_id: in_trip.user_id, parent_id: in_trip, city: city, state: state, country: country)
    puts "CITY: #{designated_trip.try(:city)}"
    self.trip = designated_trip
    type_list.add metadata.type
    type_list.remove 'Unassigned' if type_list.count > 1
    return false if !valid?
  end

  def comment_attributes=(attrs)
    comment.try(:delete)
    super
  end

  def date=(date)
    date = date.to_date
    date_list.add date.strftime("%B #{date.day.ordinalize}") unless date.blank?
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

  def ensure_tagged
    day_list.add 'Unassigned' if day_list.empty? && !scheduled?
    type_list.add 'Unassigned' if type_list.empty?
  end

  def set_location
    self.latitude = latitude
    self.longitude = longitude
  end

  def link?
    !!(uri =~ /https?:/) && user_provided_name == uri
  end

  def yelp?
    !!(uri =~ /yelp\..{2,3}\/biz\//)
  end

  def tripadvisor?
    !!(uri =~ /tripadvisor\..{2,3}\/.+_Review/)
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
    @google_places ||= GooglePlacesMetaData.new(user_provided_name, near, reference)
  end

  def weblink
    @weblink ||= WeblinkMetaData.new(uri)
  end

  def source
    if yelp?
      "Yelp"
    elsif tripadvisor?
      "TripAdvisor"
    elsif link?
      "Web Link"
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
      elsif link?
        weblink
      else
        google_places.has_any_data? ? google_places : weblink
      end
  rescue GooglePlacesMetaData::NoGooglePlacesRecordFoundError
    Rails.logger.warn "No spots found. failed for terms #{uri}"
    nil
  end

end
