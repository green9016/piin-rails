# frozen_string_literal: true

class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :user, index: true, null: false
      t.references :pin, index: true, null: false
      t.string :stripe_id
      t.string :company_name
      t.float :total
      t.date :date
      t.string :email
      t.string :status
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
  end
end
