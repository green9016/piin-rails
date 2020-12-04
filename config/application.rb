# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PinApi
  class Application < Rails::Application
    # Rails configuration
    config.load_defaults 5.2
    config.api_only = true

    # Timezone config
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.time_zone_aware_types = %i[datetime time]

    # Locale config
    config.i18n.default_locale = 'en'

    # Rack attack
    config.middleware.use Rack::Attack

    # Send logs to STDOUT
    config.log_level = ENV['LOG_LEVEL']
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags = %i[subdomain uuid]
    config.logger = ActiveSupport::TaggedLogging.new(logger)

    # Lograge
    config.lograge.enabled = false
    config.lograge.formatter = Lograge::Formatters::Logstash.new

    # Disable assets and helper generators
    config.generators.assets = false
    config.generators.helper = false

    # Don't allow public files
    config.public_file_server.enabled = true

    # Active Storage variant processor
    config.active_storage.variant_processor = :vips

    # Cache config
    config.cache_store = :redis_cache_store, { driver: :hiredis, url: "#{ENV['REDIS_URL']}/#{ENV['REDIS_CACHE_PATH']}" }

    # ActiveJob with Sidekiq
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{Rails.env}"

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Skylight environments
    config.skylight.environments += [:development]
  end
end
