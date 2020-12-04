# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.belongs_to :call, foreign_key: true, null: false, index: true
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.text :content, null: false
      t.string :read_by, null: false, default: ''
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
