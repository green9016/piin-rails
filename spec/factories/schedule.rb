# frozen_string_literal: true

FactoryBot.define do
  factory :schedule do
    scheduleable_type { 'Firm' }
    scheduleable_id { Firm.last.id }
    week_day { 2 }
    starts { Faker::Date.between(2.days.ago, Date.today) }
    ends { Faker::Date.between(1.days.ago, Date.today) }
  end
end
