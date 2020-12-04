# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :firm, foreign_key: true, null: false, index: true
      t.string :photo, null: false
      t.string :title, null: false
      t.text :description
      t.string :color_code
      t.string :kinds, null: false, default: ''
      t.integer :status, null: false, default: 1
      t.boolean :deleted, null: false, default: false
      t.datetime :disabled_at
      t.boolean :checked, default: false
      t.belongs_to :business, foreign_key: true, index: true

      t.timestamps
    end
  end
end
