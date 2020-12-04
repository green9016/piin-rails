# frozen_string_literal: true

class CreateFirms < ActiveRecord::Migration[5.1]
  def change
    create_table :firms do |t|
      t.string :photo
      t.string :name, null: false
      t.text :about
      t.string :state
      t.string :city
      t.string :street
      t.string :zip
      t.string :phone_number, null: false
      t.string :website
      t.float :lat, null: false, default: 0.0
      t.float :lng, null: false, default: 0.0
      t.integer :status, null: false, default: 1
      t.boolean :deleted, null: false, default: false
      t.boolean :checked, default: false
      t.belongs_to :owner, foreign_key: { to_table: :businesses }, index: true
      t.string :business_type

      t.timestamps
    end
  end
end
