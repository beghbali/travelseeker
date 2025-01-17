require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Zentrips
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    config.assets.paths << "#{Rails.root}/app/assets/trips"
    config.assets.precompile += %w( clips.js clips.css trips.js trips.css)

    config.generators do |g|
      g.template_engine :slim
    end
    # config.react.server_renderer_options = {
    #     files: ["server_render.js"] # files to load for prerendering
    # }

    # config.time_zone = 'Pacific Time (US & Canada)'
    # config.active_record.default_timezone = 'UTC'
    # config.active_record.default_timezone = 'Pacific Time (US & Canada)'
    config.assets.initialize_on_precompile = false
  end
end
