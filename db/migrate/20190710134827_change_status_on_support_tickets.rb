class ChangeStatusOnSupportTickets < ActiveRecord::Migration[5.2]
  def change
    change_column :support_tickets, :status, :integer, default: 0
  end
end
