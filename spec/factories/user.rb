# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    photo { File.open(Rails.root.join('spec/support/default.jpeg')) }
    email { Faker::Internet.unique.email }
    password { '12345678' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.unique.username }
    birthday { Faker::Date.between(10.years.ago, Date.today) }
    confirmed_at { Time.zone.now }
    status { rand(0..1) }

    # after :create do |user|
    #   create(:company, user: user)
    # end
  end
end
