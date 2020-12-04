# frozen_string_literal: true

class CreateActions < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.belongs_to :firm, foreign_key: true, null: false, index: true
      t.belongs_to :pin, foreign_key: true, null: false, index: true
      t.belongs_to :post, foreign_key: true, null: false, index: true
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.string :type, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
