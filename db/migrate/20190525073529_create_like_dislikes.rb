# frozen_string_literal: true

class CreateLikeDislikes < ActiveRecord::Migration[5.2]
  def change
    create_table :like_dislikes do |t|
      t.integer :post_id
      t.integer :user_id
      t.boolean :is_like, default: true
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
  end
end
