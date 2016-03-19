class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'clips'

  helper_method :current_user
  helper_method :signed_in?

  def faq
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) || User.new(trips: session.id ? Trip.where(session_id: session.id) : [])
  end

  def signed_in?
    current_user.id.present?
  end

  def sign_out
    session[:user_id] = nil
    redirect_to "https://zentrips.auth0.com/v2/logout?returnTo=http://www.tryzentrips.com/"
  end

  def sign_in(email, uid)
    if email.present?
      user = User.find_or_create_by_email(email)
      user.update(uid: uid) if uid.present? && user.uid.nil?
      return false if user.persisted? && uid.present? && user.uid != uid
    elsif uid.present?
      user = User.find_or_create_by_uid(uid)
    end
    Rails.logger.error "#{email}, #{uid}, #{user.inspect}"
    session[:user_id] = user.try(:id)
    session[:user_id].present?
  end

  def claim_trips
    current_user.claim_trips_for_session!(session.id)
  end
end
