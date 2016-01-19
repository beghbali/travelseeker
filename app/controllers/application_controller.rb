class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'clips'

  helper_method :current_user

  def faq
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) || User.new(trips: Trip.where(session_id: session.id))
  end
end
