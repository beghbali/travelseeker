Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV['AUTH0_KEY'],
    ENV['AUTH0_SECRET'],
    'zentrips.auth0.com',
    callback_path: "/auth/auth0/callback"
  )
end