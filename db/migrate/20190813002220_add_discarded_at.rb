class AddDiscardedAt < ActiveRecord::Migration[5.2]
  def change

    add_column :visited_locations, :discarded_at, :datetime
    add_column :flags, :discarded_at, :datetime
    add_column :schedules, :discarded_at, :datetime
    add_column :pin_balances, :discarded_at, :datetime
    add_column :like_dislikes, :discarded_at, :datetime
    add_column :offers, :discarded_at, :datetime
    add_column :views, :discarded_at, :datetime
    add_column :users, :discarded_at, :datetime
    add_column :alerts, :discarded_at, :datetime
    add_column :locations, :discarded_at, :datetime

    add_index :visited_locations, :discarded_at
    add_index :flags, :discarded_at
    add_index :schedules, :discarded_at
    add_index :pin_balances, :discarded_at
    add_index :like_dislikes, :discarded_at
    add_index :offers, :discarded_at
    add_index :views, :discarded_at
    add_index :users, :discarded_at
    add_index :alerts, :discarded_at
    add_index :locations, :discarded_at

  end
end
