# frozen_string_literal: true

class CreateVisitedLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :visited_locations do |t|
      t.float :lat
      t.float :lng
      t.belongs_to :user, index: true
      t.belongs_to :pin, index: true
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
  end
end
