class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'clips'

  helper_method :current_user
  helper_method :signed_in?
  helper_method :heap_event

  def faq
  end

  def current_user
    @current_user ||= (User.find_by_id(session[:user_id]) || User.new(trips: session.id ? Trip.where(session_id: session.id) : []))
  end

  def signed_in?
    current_user.id.present?
  end

  def sign_out
    reset_session
    redirect_to "https://zentrips.auth0.com/v2/logout?returnTo=https://travelseeker.herokuapp.com/trips/new&client_id=#{ENV['AUTH0_KEY']}"
  end

  def sign_in(email, uid, image)
    if email.present?
      user = User.find_or_create_by_email(email)
      user.update(uid: uid) if uid.present? && user.uid.nil?
      return false if user.persisted? && uid.present? && user.uid != uid
    elsif uid.present?
      user = User.find_or_create_by_uid(uid)
    end
    user.update(remote_image_url: image) if user.present? && image.present? && user.image.nil?
    session[:user_id] = user.try(:id)
    session[:user_id].present?
  end

  def claim_trips
    current_user.claim_trips_for_session!(session.id)
  end

  def report
    internal_user_ids = [1,3,8,9,10,11,12,13,14,16,17,37,44,45,46,9,8,10,70,13,71,72,74,75,77,78,18,79,80]
    trips = Trip.where(parent_id: nil).where('user_id not in(?)', internal_user_ids)
    users = User.where('id not in (?)', internal_user_ids)
    clip_count = trips.map(&:all_clips).flatten.count

    report = {
      total_trips: trips.count,
      total_users: users.count,
      total_clips: clip_count,
      new_users_this_week: users.this_week.count,
      new_trips_this_week: trips.this_week.count,
      users_week_over_week_growth: users.this_week.count.to_f/(users.count - users.this_week.count),
      trips_week_over_week_growth: trips.this_week.count.to_f/(trips.count - trips.this_week.count),
      clips_per_trip: clip_count/trips.count.to_f
    }
    render inline: report.to_json
  end

  def heap_event(event_name, properties)
    HTTParty.post('https://heapanalytics.com/api/track', headers: {'Content-Type' => 'application/json'},
      body: {app_id: '2977918096', identity: current_user.email || session.id, event: event_name, properties: properties}.to_json)
  end
end
