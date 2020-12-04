# frozen_string_literal: true

class CreateFlags < SeedMigration::Migration
  def up
    Firm.find_each do |firm|
      (0..5).to_a.sample.times do
        feature = Feature.order('RANDOM()').first
        firm.features << feature unless firm.feature_ids.include?(feature.id)
      end
    end
  end

  def down; end
end
