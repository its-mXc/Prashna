
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prashna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.active_storage.variant_processor = :vips


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.routes.default_url_options[:host] = "prashna"
  end

  config.stripe.secret_key = ENV["stripe_secret_key"]
  config.stripe.publishable_key = ENV["stripe_publishable_key"]
end

Rails.application.routes.default_url_options[:host] = ENV['host']
