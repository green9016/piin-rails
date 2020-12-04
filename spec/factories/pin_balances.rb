FactoryBot.define do
  factory :pin_balance do
    pin
    firm
    amount_in_cents { 500 }
  end
end
