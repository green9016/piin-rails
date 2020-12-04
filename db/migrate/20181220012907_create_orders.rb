# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :firm, foreign_key: true, null: false, index: true
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.string :code, null: false
      t.float :value, null: false
      t.string :stripe_charge_token
      t.string :stripe_charge_status
      t.string :stripe_charge_message, null: false
      t.integer :status, null: false, default: 1
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :orders, :code, unique: true
    add_index :orders, :stripe_charge_token, unique: true
  end
end
