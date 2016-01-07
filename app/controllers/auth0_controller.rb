class Auth0Controller < ApplicationController
  before_action :set_redirect_path

  def callback
    user_info = request.env['omniauth.auth']
    user = User.find_or_create_by_email(user_info[:info][:email])
    user.claim_trips_for_session!(session[:id])
    redirect_to @redirect_path
  end

  def failure
    error_message = request.params['message']

    redirect_to @redirect_path, flash: {error: error_message}
  end

  private def set_redirect_path
    user_trips = Trip.find_by_session_id(session[:id])

    if user_trips.nil?
      @redirect_path = new_trip_path
    else
      @redirect_path = trip_path(user_trips.last)
    end
  end
end
