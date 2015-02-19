class RequestsController < ApplicationController
  layout 'requests'

  def new

  end

  def create
    params.require(:request).permit!
    RequestMailer.new_request(params[:request])
    redirect_to thank_you_requests_path
  end

  def thank_you
  end
end