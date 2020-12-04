# frozen_string_literal: true

FactoryBot.define do
  factory :purchase do
    user
    pin
    firm
    company_name {  Faker::Company.name }
    total { Faker::Number.number(3) }
    date { Faker::Date.between(6.days.ago, Date.today) }
    email { Faker::Internet.unique.email }
    status { rand(0..1) }
  end
end