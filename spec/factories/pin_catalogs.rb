FactoryBot.define do
  factory :pin_catalog do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    banner { File.open(Rails.root.join('spec/support/default.jpeg')) }
    icon { Faker::Lorem.characters(16) }
    color { Faker::Color.color_name }
    miles { 10 }
    range { 5 }
    duration_in_days { 31 }
    daily_price_in_cents { 100 }
  end
end
