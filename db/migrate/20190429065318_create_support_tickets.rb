# frozen_string_literal: true

class CreateSupportTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :support_tickets do |t|
      t.references :user
      t.string :description
      t.integer :status
      t.boolean :deleted, null: false, default: false
      t.integer :assignee_id
      t.text :query
      t.boolean :checked
      t.references :ticketable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
