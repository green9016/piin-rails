FactoryBot.define do
  factory :firm_report do
    month { 1 }
    year { 1 }
    total_spent_cents { 1 }
    daily_spent_cents { 1 }
    total_likes { 1 }
    pins_purchased { 1 }
    people_reached { 1 }
    firm { nil }
  end
end
