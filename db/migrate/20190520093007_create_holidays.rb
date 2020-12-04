# frozen_string_literal: true

class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.string :title, null: false
      t.string :post_photo
      t.string :icon_photo
      t.datetime :from_date, null: false
      t.datetime :until_date, null: false
      t.integer :status, default: 1
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :holidays, :title, unique: true
  end
end
