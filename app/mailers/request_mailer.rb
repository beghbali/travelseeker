class RequestMailer < ActionMailer::Base

  default from: 'support@zentrips.co'

  def new_request(params)
    mail(
      to: 'support@zentrips.co',
      subject: "Zentrip [new-request]: #{params[:name]}, #{params[:destination]}, #{params[:arrival]}, #{params[:budget]}",
      body: params.map{|k,v| "#{k}: #{v}"}.join("\n"))
  end
end