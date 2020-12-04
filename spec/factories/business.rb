# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    email { Faker::Internet.unique.email }
    password { '12345678' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.unique.username }
    birthday { Faker::Date.between(10.years.ago, Date.today) }
    confirmed_at { Time.zone.now }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    status { rand(0..1) }
    photo { File.open(Rails.root.join('spec/support/default.jpeg')) }

    after :create do |business|
      create(:firm, owner: business)
    end
  end
end
