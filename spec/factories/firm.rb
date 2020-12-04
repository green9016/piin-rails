# frozen_string_literal: true

FactoryBot.define do
  factory :firm do
    association :owner, factory: :business

    photo { File.open(Rails.root.join('spec/support/default.jpeg')) }
    name { Faker::Company.name }
    phone_number { Faker::PhoneNumber.phone_number }
    about { Faker::Company.bs }
    website { Faker::Internet.url }
    state { Faker::Address.state }
    city { Faker::Address.city }
    street { Faker::Address.street_name }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    status { rand(0..1) }
    checked { Faker::Boolean.boolean(0.2) }

    after :create do |firm|
      create_list(:pin, 10, firm: firm, business: firm.owner)
      create_list(:post, 10, firm: firm, business: firm.owner)
    end
  end
end
