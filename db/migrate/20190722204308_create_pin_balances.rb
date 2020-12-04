class CreatePinBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :pin_balances do |t|
      t.references :pin, foreign_key: true
      t.references :firm, foreign_key: true
      t.integer :amount_in_cents, null: false

      t.timestamps
    end
  end
end
