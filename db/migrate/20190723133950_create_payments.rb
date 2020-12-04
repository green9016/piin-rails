class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :business, foreign_key: true
      t.references :firm, foreign_key: true
      t.references :pin, foreign_key: true
      t.integer :amount_in_cents, null: false
      t.string :stripe_charge_id, null: false

      t.timestamps
    end
  end
end
