# frozen_string_literal: true

class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.references :callable, polymorphic: true
      t.string :code, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.string :extras
      t.string :type, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :calls, :code, unique: true
  end
end
