# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'addressable'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan'
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'carrierwave-processing'
gem 'codacy-coverage', :require => false
gem 'devise'
gem 'devise_token_auth'
gem 'dotenv-rails'
gem 'faraday'
gem 'fog-google'
gem 'friendly_id'
gem 'geocoder'
gem 'hiredis'
gem 'image_processing', '~> 1.2'
gem 'jsonapi-rails'
gem 'kaminari'
gem 'lograge'
gem 'logstash-event'
gem 'mini_magick'
gem 'money-rails'
gem 'oj'
gem 'pager_api'
gem 'pagy'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack-attack'
gem 'rack-cors'
gem 'rack-timeout'
gem 'rails', '~> 5.2.3'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'redis', '~> 4.0'
gem 'ruby-holidayapi'
gem 'seed_migration'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'skylight'
gem 'stripe'
gem 'twilio-ruby'
gem 'discard', '~> 1.0'

group :development, :test, :staging do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-json_expectations'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop-performance'
  gem 'rubocop-rails_config'
  gem 'rubocop-rspec'
end

group :development do
  gem 'active_record_query_trace'
  gem 'annotate'
  gem 'brakeman'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end
