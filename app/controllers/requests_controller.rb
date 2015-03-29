class RequestsController < ApplicationController
  layout 'requests'

  def new
    @destination = params[:destination]
  end

  def create
    params.require(:request).permit!
    RequestMailer.new_request(params[:request]).deliver
    redirect_to thank_you_requests_path
  end

  def thank_you
  end
end