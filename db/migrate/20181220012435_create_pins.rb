# frozen_string_literal: true

class CreatePins < ActiveRecord::Migration[5.1]
  def change
    create_table :pins do |t|
      t.string :title
      t.belongs_to :firm, foreign_key: true, null: false, index: true
      t.string :icon, null: false
      t.string :colour, null: false
      t.float :range, null: false
      t.integer :duration, null: false
      t.integer :daily_price_in_cents, null: false
      t.float :lat, null: false, default: 0.0
      t.float :lng, null: false, default: 0.0
      t.integer :status, null: false, default: 1
      t.boolean :deleted, null: false, default: false
      t.belongs_to :business, foreign_key: true, index: true

      t.timestamps
    end
  end
end
