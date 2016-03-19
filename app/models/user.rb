class User < ActiveRecord::Base
  has_many :trips, -> { top_level }

  validates :email, uniqueness: true, allow_nil: true

  def claim_trips_for_session!(session_id)
    Trip.where(session_id: session_id).where('user_id is NULL').update_all(user_id: self.id)
  end
end
