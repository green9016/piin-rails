# frozen_string_literal: true

class CreateParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :participations do |t|
      t.belongs_to :call, foreign_key: true, null: false, index: true
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
