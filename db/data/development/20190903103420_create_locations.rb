# frozen_string_literal: true

class CreateLocations < SeedMigration::Migration
  def up
    User.find_each do |user|
      (1..100).to_a.sample.times do
        user.locations.create!(
          lat: Faker::Address.latitude,
          lng: Faker::Address.longitude,
        )
      end
    end
  end

  def down; end
end
