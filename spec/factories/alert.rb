FactoryBot.define do
  factory :alert do
    user
    notification
    active { Faker::Boolean.boolean(0.2) }
  end
end
