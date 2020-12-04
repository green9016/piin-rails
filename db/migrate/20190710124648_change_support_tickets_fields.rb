class ChangeSupportTicketsFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :support_tickets, :assignee_id, :integer
    remove_column :support_tickets, :description, :integer

    add_reference :support_tickets, :admin, index: true
  end
end
