# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[5.2]
  def change # rubocop:disable Metrics/MethodLength
    create_table :reports do |t|
      t.belongs_to :user, index: true
      t.belongs_to :post, index: true
      t.text :description
      t.boolean :wrong_location, default: false
      t.boolean :false_offers, default: false
      t.boolean :incorrect_open_hours, default: false
      t.boolean :different_business_name, default: false
      t.boolean :other_reason, default: false
      t.boolean :deleted, null: false, default: false
      t.boolean :checked, default: false
      t.integer :status
      t.timestamps
    end
  end
end
