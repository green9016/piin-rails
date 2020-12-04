class AddSettingsToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :settings, :jsonb, default: {}, null: false
  end
end
