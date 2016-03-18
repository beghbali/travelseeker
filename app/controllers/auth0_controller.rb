class Auth0Controller < ApplicationController

  def callback
    user_info = request.env['omniauth.auth']
    Rails.logger.error user_info.inspect
    user = User.find_or_create_by_email(user_info[:info][:email])
    user.claim_trips_for_session!(session.id)
    session[:user_id] = user.id
    redirect_to after_sign_in_path
  end

  def failure
    error_message = request.params['message']

    redirect_to after_sign_in_path, flash: {error: error_message}
  end

  private def after_sign_in_path
    trip = current_user.trips.last
    trip.present? ? trip_path(trip) : new_trip_path
  end
end
