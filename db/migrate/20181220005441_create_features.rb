# frozen_string_literal: true

class CreateFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :features do |t|
      t.string :icon, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :features, :name, unique: true
  end
end
