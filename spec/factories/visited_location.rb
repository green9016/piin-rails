# frozen_string_literal: true

FactoryBot.define do
  factory :visited_location do
    pin
    user
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end
