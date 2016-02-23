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
    @current_user ||= User.find_by_id(session[:user_id]) || User.new(trips: Trip.where(session_id: session.id))
  end

  def signed_in?
    current_user.id.present?
  end
end
