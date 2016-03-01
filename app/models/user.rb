class User < ActiveRecord::Base
  has_many :trips

  def claim_trips_for_session!(session_id)
    Trip.where(session_id: session_id).where('user_id is NULL').update_all(user_id: self.id)
  end
end
