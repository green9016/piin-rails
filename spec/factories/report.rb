# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    post
    user
    description { Faker::Lorem.paragraph }
    wrong_location { Faker::Boolean.boolean(0.2) }
    false_offers { Faker::Boolean.boolean(0.2) }
    incorrect_open_hours { Faker::Boolean.boolean(0.2) }
    different_business_name { Faker::Boolean.boolean(0.2) }
    other_reason { Faker::Boolean.boolean(0.2) }
    status { rand(0..1) }
    checked { Faker::Boolean.boolean(0.2) }
  end
end
