require "bundler/setup"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module RailsApiMinimal
  class Application < Rails::Application
    config.load_defaults 7.2
    config.api_only = true
    config.eager_load = Rails.env.production?

    # Without this, production logs to log/production.log and `docker logs` is empty.
    config.logger = ActiveSupport::Logger.new($stdout) if Rails.env.production?
  end
end
