# frozen_string_literal: true

class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.belongs_to :post, foreign_key: true, null: false, index: true
      t.string :title, null: false
      t.float :price
      t.integer :percent
      t.integer :status, null: false, default: 1
      t.boolean :deleted, null: false, default: false
      t.string :start_time, null: false, default: '00:00'
      t.string :end_time, null: false, default: '23:59'
      t.string :week_days, array: true, default: [], null: false

      t.timestamps
    end
  end
end
