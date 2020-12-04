# frozen_string_literal: true

class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :scheduleable, polymorphic: true
      t.integer :week_day, null: false
      t.time :starts, null: false
      t.time :ends, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
