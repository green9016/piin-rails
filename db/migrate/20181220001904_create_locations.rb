# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.float :lat, null: false, default: 0.0
      t.float :lng, null: false, default: 0.0
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
