# frozen_string_literal: true

class CreateViews < ActiveRecord::Migration[5.2]
  def change
    create_table :views do |t|
      t.belongs_to :user, index: true
      t.belongs_to :post, index: true
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
  end
end
