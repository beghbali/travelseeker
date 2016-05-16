class User < ActiveRecord::Base
  has_many :trips, -> { top_level }

  validates :email, uniqueness: true, allow_nil: true

  def claim_trips_for_session!(session_id)
    Trip.unclaimed.where(session_id: session_id).update_all(user_id: self.id)
  end

  def last_trip_copied_to
    @last_clip ||= Clip.copied.where(trip_id: trips.map(&:id)).order(created_at: :desc).first
    @last_clip.try(:trip).try(:parent)
  end

  def authored? trip
    trip.user == self
  end
end
