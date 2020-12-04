FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    username { Faker::Lorem.characters(10) }
    password { Devise::Encryptor.digest(Admin, '123456789') }
  end
end
