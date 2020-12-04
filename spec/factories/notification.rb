FactoryBot.define do
  factory :notification do
    name { Faker::Name.unique.name }
    business { true }
    description { Faker::Company.bs }
  end
end
