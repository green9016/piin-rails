# frozen_string_literal: true

class CreateTrustees < ActiveRecord::Migration[5.1]
  def change
    create_table :trustees do |t|
      t.belongs_to :firm, foreign_key: true, null: false, index: true
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.integer :role, null: false, default: 1
      t.integer :status, null: false, default: 1
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
