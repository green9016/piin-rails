# frozen_string_literal: true

FactoryBot.define do
  factory :feature do
    icon { Faker::Lorem.word }
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
  end
end
