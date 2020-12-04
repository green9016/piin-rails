# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :business, null: false, default: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :notifications, :name, unique: true
  end
end
