# frozen_string_literal: true

FactoryBot.define do
  factory :pin do
    firm
    business
    pin_catalog
    icon { Faker::Lorem.characters(16) }
    colour { Faker::Color.color_name }
    range { Faker::Number.number(3) }
    duration { Faker::Number.number(2) }
    daily_price_in_cents { Faker::Number.number(3) }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    status { rand(0..1) }
  end
end
