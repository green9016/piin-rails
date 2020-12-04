FactoryBot.define do
  factory :payment do
    business { nil }
    firm { nil }
    pin { nil }
    amount_in_cents { 1 }
  end
end
