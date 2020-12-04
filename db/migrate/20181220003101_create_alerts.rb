# frozen_string_literal: true

class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.belongs_to :notification, foreign_key: true, index: true, null: false
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.boolean :active, null: false, default: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
