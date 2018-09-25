require_relative("boot")

require("open-uri")
require("net/http")
require("ostruct")
require("rails")
# Pick the frameworks you want:
require("active_model/railtie")
require("active_job/railtie")
require("active_record/railtie")
require("action_controller/railtie")
require("action_mailer/railtie")
require("action_view/railtie")
require("action_cable/engine")
require("active_storage/engine")
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require("sidekiq/web")
require("sidekiq_unique_jobs/web")
require("sidecloq/web")

require_relative("../lib/source")

module Bountycall
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(5.2)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators.assets = false
    config.generators.helper = false

    # by default tables should have uuid primary keys
    config.generators do |generator|
      generator.orm(:active_record, :primary_key_type => :uuid)
    end

    config.action_controller.include_all_helpers = false
    config.active_record.schema_format = :sql
    config.active_job.queue_adapter = :sidekiq

    # Set the application-level cache
    config.cache_store = [
      :redis_cache_store,
      {
        :driver => :hiredis,
        :expires_in => 30.minutes,
        :compress => true,
        :redis => Bountycall::REDIS_CACHE_CONNECTION_POOL
      }
    ]

    # Set the http-level caching
    config.action_controller.perform_caching = true
    config.action_mailer.perform_caching = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{Integer(1.week.seconds)}"
    }

    # Uses the tags defined below to create logs that are easily grep-able.
    unless Rails.env.test?
      config.logger = ActiveSupport::TaggedLogging.new(
        ActiveSupport::Logger.new(STDOUT)
      )
    end

    # Each of the below adds one informational piece to each logline
    config.log_tags = [
      ->(_) do "time=#{Time.now.iso8601}" end,
      ->(request) do
        "remote-ip=#{request.remote_ip}" if request.remote_ip
      end,
      ->(request) do
        if request.cookie_jar.encrypted.try!(:[], config.session_options[:key]).try!(:[], "session_id")
          "session-id=#{request.cookie_jar.encrypted.try!(:[], config.session_options[:key]).try!(:[], "session_id")}"
        end
      end,
      ->(request) do
        "context-id=#{request.request_id}" if request.request_id
      end
    ]
    config.action_cable.log_tags = [
      :action_cable,
      ->(request) {request.uuid}
    ]

    if ENV.fetch("HEROKU_APP_NAME", nil)
      Rails.application.config.action_controller.default_url_options = {
        :host => "#{ENV.fetch("HEROKU_APP_NAME")}.herokuapp.com"
      }
      Rails.application.config.action_mailer.default_url_options = {
        :host => "#{ENV.fetch("HEROKU_APP_NAME")}.herokuapp.com"
      }
    elsif Rails.env.production?
      Rails.application.config.action_controller.default_url_options = {
        :host => ENV.fetch("RAILS_HOST")
      }
      Rails.application.config.action_mailer.default_url_options = {
        :host => ENV.fetch("RAILS_HOST")
      }
    else
      Rails.application.config.action_controller.default_url_options = {
        :host => ENV.fetch("RAILS_HOST"),
        :port => Integer(ENV.fetch("PORT"))
      }
      Rails.application.config.action_mailer.default_url_options = {
        :host => ENV.fetch("RAILS_HOST"),
        :port => Integer(ENV.fetch("PORT"))
      }
    end
  end
end
