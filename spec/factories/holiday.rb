FactoryBot.define do
  factory :holiday do
    title { Faker::Lorem.characters(8) }
    post_photo { Faker::Lorem.characters(16) }
    icon_photo { Faker::Lorem.characters(16) }
    from_date { Faker::Date.between(5.days.ago, Date.today) }
    until_date { Faker::Date.between(5.days.ago, Date.today) }
    status { rand(0..1) }
  end
end
