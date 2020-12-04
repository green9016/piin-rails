class RemoveDeletedFromAllTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :deleted, :boolean
    remove_column :actions, :deleted, :boolean
    remove_column :admins, :deleted, :boolean
    remove_column :alerts, :deleted, :boolean
    remove_column :businesses, :deleted, :boolean
    remove_column :calls, :deleted, :boolean
    remove_column :features, :deleted, :boolean
    remove_column :firms, :deleted, :boolean
    remove_column :flags, :deleted, :boolean
    remove_column :holidays, :deleted, :boolean
    remove_column :like_dislikes, :deleted, :boolean
    remove_column :locations, :deleted, :boolean
    remove_column :messages, :deleted, :boolean
    remove_column :notifications, :deleted, :boolean
    remove_column :offers, :deleted, :boolean
    remove_column :orders, :deleted, :boolean
    remove_column :participations, :deleted, :boolean
    remove_column :pins, :deleted, :boolean
    remove_column :posts, :deleted, :boolean
    remove_column :purchases, :deleted, :boolean
    remove_column :reports, :deleted, :boolean
    remove_column :schedules, :deleted, :boolean
    remove_column :support_tickets, :deleted, :boolean
    remove_column :trustees, :deleted, :boolean
    remove_column :views, :deleted, :boolean
    remove_column :visited_locations, :deleted, :boolean
  end
end
