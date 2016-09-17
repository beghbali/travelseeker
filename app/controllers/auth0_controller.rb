class Auth0Controller < ApplicationController
  layout 'trips'

  before_action :set_email_and_uid, only: :confirm_email

  def callback
    user_info = request.env['omniauth.auth']
    @email = user_info[:info][:email]
    @uid = user_info[:uid]
    @image = user_info[:info][:picture]

    Rails.logger.error "#{@email}, #{@uid}"

    if @email.present? || @uid.present?
      confirm_email
    else
      redirect_to new_trip_path
    end
  end

  def failure
    error_message = request.params['message']

    redirect_to after_sign_in_path, flash: {error: error_message}
  end

  def provide_email
    flash.clear
  end

  def confirm_email
    if sign_in(@email, @uid, @image)
      claim_trips
      redirect_to after_sign_in_path
    else
      redirect_to provide_email_auth0_path, flash: { error: 'Please provide an email address'}
    end
  end

  private def after_sign_in_path
    if session[:redirect_to].present?
      session.delete(:redirect_to)
    else
      # this should be last user clip activity and it's ancestor trip
      trip = current_user.last_trip_copied_to || current_user.trips.last
      trip.present? ? trip_path(trip) : new_trip_path
    end
  end

  private def user_params
    params.require(:user).permit(:email, :uid)
  end

  private def set_email_and_uid
    @email = user_params[:email]
    @uid = user_params[:uid]
  end

end
