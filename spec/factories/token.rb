# frozen_string_literal: true

FactoryBot.define do
  factory :token do
    key { Faker::Device.serial }
  end
end
