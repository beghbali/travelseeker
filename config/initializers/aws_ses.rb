$ses = AWS::SES::Base.new(
  :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :server            => 'email-smtp.us-west-2.amazonaws.com'
)