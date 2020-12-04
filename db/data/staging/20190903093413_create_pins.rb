# frozen_string_literal: true

class CreatePins < SeedMigration::Migration
  def up
    Firm.find_each do |firm|
      (0..20).to_a.sample.times do
        pin_catalog = PinCatalog.order('RANDOM()').first

        firm.pins.create!(
          business: firm.owner,
          pin_catalog: pin_catalog,
          icon: pin_catalog.icon,
          colour: pin_catalog.color,
          range: pin_catalog.range,
          duration: pin_catalog.duration_in_days,
          daily_price_in_cents: pin_catalog.daily_price_in_cents,
          initial_balance_in_cents: pin_catalog.daily_price_in_cents * pin_catalog.duration_in_days,
          lat: Faker::Address.latitude,
          lng: Faker::Address.longitude,
          status: rand(0..1)
        )
      end
    end
  end

  def down; end
end
