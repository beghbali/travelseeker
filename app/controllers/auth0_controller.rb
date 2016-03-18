class Auth0Controller < ApplicationController

  def callback
    user_info = request.env['omniauth.auth']
    email = user_info[:info][:email]

    puts user_info.inspect
    if email.present?
      @email = email
      confirm_email
    else
      redirect_to provide_email_auth0_path
    end
  end

  def failure
    error_message = request.params['message']

    redirect_to after_sign_in_path, flash: {error: error_message}
  end

  def provide_email
  end

  def confirm_email
    sign_in(@email || user_params[:email])
    claim_trips
    redirect_to after_sign_in_path
  end

  private def after_sign_in_path
    trip = current_user.trips.last
    trip.present? ? trip_path(trip) : new_trip_path
  end

  private def user_params
    params.require(:user).permit(:email)
  end
end
