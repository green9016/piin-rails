class AddSeenAtToVisitedLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :visited_locations, :seen_at, :timestamp, default: nil
    add_index :visited_locations, :seen_at
  end
end
