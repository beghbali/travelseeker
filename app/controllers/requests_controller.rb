class RequestsController < ApplicationController
  layout 'requests'

  def new

  end

  def create
    params.require(:request).permit(user_attributes: [:first_name, :email])
    RequestMailer.new_request(params).deliver!
    redirect_to thank_you_requests_path
  end

  def thank_you
  end
end