require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CobudgetApi
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

    # Required to be false for session_store
    # config.api_only = false

    config.active_record.raise_in_transactional_callbacks = true
    config.middleware.use Rack::Cors do
    #config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          :methods => [:get, :post, :options, :delete, :put, :patch]
      end
    end

    config.to_prepare do
      Devise::PasswordsController.skip_before_filter :authenticate_from_token!,
                                                     only: [:create, :update]
    end

    config.active_job.queue_adapter = :delayed_job

    config.eager_load_paths += %W( #{config.root}/services )
    config.eager_load_paths += %W( #{config.root}/extras )
    config.eager_load_paths += %W( #{config.root}/lib/core_ext )

    config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"

    ActiveSupport.encode_big_decimal_as_string = false
  end
end
