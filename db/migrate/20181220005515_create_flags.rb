# frozen_string_literal: true

class CreateFlags < ActiveRecord::Migration[5.1]
  def change
    create_table :flags do |t|
      t.belongs_to :feature, foreign_key: true, null: false, index: true
      t.belongs_to :firm, foreign_key: true, null: false, index: true
      t.boolean :active, null: false, default: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
