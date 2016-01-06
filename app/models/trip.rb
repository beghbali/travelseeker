class Trip < ActiveRecord::Base
  has_many :clips
  belongs_to :user

  accepts_nested_attributes_for :clips

  def location
    Location.new(self.slice(:latitude, :longitude))
  end

  def name
    self[:location]
  end

  def context
    start_date.nil? ? 'Days' : starte_data.strftime("%B")
  end

  def end_date=(date)
    return if date.blank?
    days = (end_date - start_date).to_i
  end

  def end_date
    start_date.nil? ? nil : start_date + days
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
