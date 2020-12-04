FactoryBot.define do
  factory :trustee do
    firm
    user
    status { rand(0..1) }
    role { rand(0..1) }
  end
end
