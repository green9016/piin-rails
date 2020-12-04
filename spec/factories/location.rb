# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    user
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end
