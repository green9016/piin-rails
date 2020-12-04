# frozen_string_literal: true

FactoryBot.define do
  factory :offer do
    post

    title { Faker::Lorem.characters }
    price { Faker::Number.decimal(2) }
    percent { Faker::Number.number(2) }
    week_days { [0, 4, 5, 6] }
    status { rand(0..1) }
  end
end
