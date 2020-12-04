class AddInitialBalanceInCentsToPins < ActiveRecord::Migration[5.2]
  def change
    add_column :pins, :initial_balance_in_cents, :integer
  end
end
