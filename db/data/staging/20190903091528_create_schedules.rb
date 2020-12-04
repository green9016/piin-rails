# frozen_string_literal: true

class CreateSchedules < SeedMigration::Migration
  def up
    Firm.find_each do |firm|
      (1..4).to_a.sample.times do
        firm.schedules.create!(
          week_day: (0..6).to_a.sample,
          starts: Time.zone.today.beginning_of_day.to_s(:time),
          ends: Time.zone.today.end_of_day.to_s(:time),
        )
      end
    end
  end

  def down; end
end
