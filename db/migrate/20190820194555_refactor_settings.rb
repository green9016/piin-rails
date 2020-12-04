class RefactorSettings < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :settings, :jsonb
    remove_column :businesses, :settings, :jsonb

    add_column :users, :settings_new_deals, :boolean, default: true, null: false
    add_column :users, :settings_timer, :boolean, default: false, null: false

    add_column :businesses, :settings_new_deals, :boolean, default: true, null: false
    add_column :businesses, :settings_likes_and_views, :boolean, default: true, null: false
  end
end
