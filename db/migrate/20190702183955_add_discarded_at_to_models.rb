class AddDiscardedAtToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :discarded_at, :datetime
    add_index :businesses, :discarded_at

    add_column :firms, :discarded_at, :datetime
    add_index :firms, :discarded_at

    add_column :holidays, :discarded_at, :datetime
    add_index :holidays, :discarded_at

    add_column :orders, :discarded_at, :datetime
    add_index :orders, :discarded_at

    add_column :pins, :discarded_at, :datetime
    add_index :pins, :discarded_at

    add_column :posts, :discarded_at, :datetime
    add_index :posts, :discarded_at

    add_column :purchases, :discarded_at, :datetime
    add_index :purchases, :discarded_at

    add_column :reports, :discarded_at, :datetime
    add_index :reports, :discarded_at

    add_column :support_tickets, :discarded_at, :datetime
    add_index :support_tickets, :discarded_at

    add_column :trustees, :discarded_at, :datetime
    add_index :trustees, :discarded_at
  end
end
