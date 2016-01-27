class Trip < ActiveRecord::Base
  auto_strip_attributes :city, :state, :country, :location, nullify: true
  has_many :clips
  belongs_to :user
  belongs_to :parent, class_name: 'Trip'
  has_many :trips, foreign_key: :parent_id

  accepts_nested_attributes_for :clips

  scope :in_city, ->(city) { where(city: city) }

  def all_clips
    Clip.joins('inner join trips on clips.trip_id = trips.id').where(trip_id: trips.pluck(:id)).order('clips.created_at')
  end

  def as_json(options={})
    super(options).merge({end_date: end_date})
  end

  def location
    Location.new(self.slice(:latitude, :longitude))
  end

  def name
    self[:location]
  end

  def context
    start_date.nil? ? 'Days' : start_date.strftime("%B")
  end

  def end_date=(date)
    return if date.blank?
    self.days = (date.to_date - start_date).to_i + 1
  end

  def days
    @days ||= begin
      if trips.any?
        last_subtrip = trips.map(&:end_date).compact.sort.last
        (last_subtrip && start_date && (last_subtrip - start_date).to_i) || 1
      else
        self[:days]
      end
    end
  end

  def start_date
    @start_date ||= self[:start_date] || trips.map(&:start_date).compact.sort.first
  end

  def end_date
    start_date.nil? ? nil : start_date + days - 2
  end

  def date_on_day(day)
    start_date.nil? ? nil : start_date + day - 1
  end

  def dates_known?
    start_date.present?
  end

  def dates
    if dates_known?
      start_date..end_date
    else
      1..days
    end
  end
end
