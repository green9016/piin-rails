# frozen_string_literal: true

class CreateBusinesses < SeedMigration::Migration
  def up
    100.times do
      Business.create! email: Faker::Internet.unique.email,
                       password: '12345678',
                       first_name: Faker::Company.name,
                       last_name: Faker::Company.suffix,
                       username: Faker::Internet.unique.username,
                       birthday: Faker::Date.between(30.years.ago, 10.years.ago),
                       confirmed_at: Time.zone.now,
                       lat: Faker::Address.latitude,
                       lng: Faker::Address.longitude,
                       status: [0, 1].sample,
                       photo: File.open(Rails.root.join('spec/support/default.jpeg')),
                       owned_firm_attributes: {
                         photo: File.open(Rails.root.join('spec/support/default.jpeg')),
                         name: Faker::Company.name,
                         phone_number: Faker::PhoneNumber.phone_number,
                         about: Faker::Company.bs,
                         website: Faker::Internet.url,
                         state: Faker::Address.state,
                         city: Faker::Address.city,
                         street: Faker::Address.street_name,
                         zip: Faker::Address.zip,
                         lat: Faker::Address.latitude,
                         lng: Faker::Address.longitude,
                         status: [0, 1].sample,
                         checked: Faker::Boolean.boolean(0.2),
                       }
    end
  end

  def down; end
end
