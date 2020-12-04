# frozen_string_literal: true

require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# Use local storage on development or test
if Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.asset_host = 'http://localhost:3000'
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = 'fog/google'

    config.fog_credentials = {
        provider: 'Google', # required
        google_project: ENV['GOOGLE_PROJECT'],
        google_json_key_string: ENV['GOOGLE_JSON_KEY_STRING'],
    }
    config.fog_directory = "pin-app-#{Rails.env}" # required
    config.fog_public = true # optional, defaults to true
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  end
end