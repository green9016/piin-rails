# frozen_string_literal: true

FactoryBot.define do
  factory :support_ticket do
    association :ticketable, factory: :user
    description { Faker::Lorem.characters(16) }
    query { Faker::Lorem.characters(16) }
    status { 'unread' }
    checked { true }
  end
end
