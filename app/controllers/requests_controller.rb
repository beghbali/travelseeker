class RequestsController < ApplicationController
  layout 'requests'

  def new
    @request = Request.new destination: params[:destination].try(:camelize)
  end

  def create
    params.require(:request).permit!
    @request = Request.new(params[:request])

    if @request.valid?
      RequestMailer.new_request(params[:request]).deliver
      redirect_to thank_you_requests_path
    else
      params[:goto] = '#getrecommendations'
      render :new
    end
  end

  def thank_you
  end
end