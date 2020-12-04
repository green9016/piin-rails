class AddDiscardedAtToPayments < ActiveRecord::Migration[5.2]
  def change

    add_column :payments, :discarded_at, :datetime

    add_index :payments, :discarded_at
  end
end
