# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    firm
    business

    photo { File.open(Rails.root.join('spec/support/default.jpeg')) }
    title { Faker::Lorem.sentence }
    kinds { Faker::Lorem.characters }
    status { rand(0..1) }
    checked { Faker::Boolean.boolean(0.2) }

    before(:create) do |post, _evaluator|
      post.offers = build_list(:offer, 2, post: post)
    end
  end
end
