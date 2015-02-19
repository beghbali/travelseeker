class RequestMailer < ActionMailer::Base

  def new_request(params)
    ses.send_email(
      source: 'support@zentrips.co',
      to: 'support@zentrips.co',
      subject: "Zentrip [new-request]: #{params[:name]}, #{params[:destination]}, #{params[:arrival]}, #{params[:budget]}",
      text_body: params.map{|k,v| "#{k}: #{v}"}.join("\n"))
  end
end