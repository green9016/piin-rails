# frozen_string_literal: true

FactoryBot.define do
  factory :flag do
    feature
    firm
    active { true }
  end
end
