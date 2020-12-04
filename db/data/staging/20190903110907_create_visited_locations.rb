# frozen_string_literal: true

class CreateVisitedLocations < SeedMigration::Migration
  def up
    Pin.find_each do |pin|
      (0..20).to_a.sample.times do
        user = User.order('RANDOM()').first
        user.visited_locations.create!(
          pin: pin,
          lat: pin.lat,
          lng: pin.lng
        )
      end
    end
  end

  def down; end
end
