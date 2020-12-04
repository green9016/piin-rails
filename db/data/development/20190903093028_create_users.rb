# frozen_string_literal: true

class CreateUsers < SeedMigration::Migration
  def up
    100.times do
      User.create! email: Faker::Internet.unique.email,
                   phone: Faker::PhoneNumber.cell_phone_with_country_code,
                   password: '12345678',
                   first_name: Faker::Name.first_name,
                   last_name: Faker::Name.last_name,
                   username: Faker::Internet.unique.username,
                   birthday: Faker::Date.between(30.years.ago, 10.years.ago),
                   confirmed_at: Time.zone.now,
                   lat: Faker::Address.latitude,
                   lng: Faker::Address.longitude,
                   status: [0, 1].sample,
                   photo: File.open(Rails.root.join('spec/support/default.jpeg'))
    end
  end

  def down; end
end
