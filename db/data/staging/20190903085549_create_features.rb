# frozen_string_literal: true

class CreateFeatures < SeedMigration::Migration
  def up
    Feature.create!(name: 'Parking', icon: 'parking', description: "Parking Available?")
    Feature.create!(name: 'Drive Thru', icon: 'driveThrough', description: "Do you have Drive Thru service?")
    Feature.create!(name: 'Valet Parking', icon: 'valetParking', description: "Location has valet parking?")
    Feature.create!(name: 'WiFi', icon: 'wifi', description: "Location has WiFi?")
    Feature.create!(name: 'Pet', icon: 'pet', description: "Is the location Pet Friendly?")
    Feature.create!(name: 'Reservation', icon: 'reservation', description: "Do I need reservations?")
    Feature.create!(name: 'Music', icon: 'music', description: "Do you have music at location?")
    Feature.create!(name: 'Alchohol', icon: 'alcohol', description: "Do you serve alcohol?")
    Feature.create!(name: 'Romantic', icon: 'heart', description: "Location has romantic atmosphere?")
    Feature.create!(name: 'Party', icon: 'party', description: "Location has groups or party events?")
    Feature.create!(name: 'Kids', icon: 'baby', description: "Is your location a good place for kids?")
  end

  def down; end
end
