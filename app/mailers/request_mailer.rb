class RequestMailer < ActionMailer::Base

  def new_request(params)
    mail(to: %w(bashir@gmail.com everitt.rory@gmail.com),
      subject: "Zentrip [new-request]: #{params[:name]}, #{params[:destination]}, #{params[:arrival]}, #{params[:budget]}",
      body: params.map{|k,v| "#{k}: #{v}"}.join("\n"))
  end
end