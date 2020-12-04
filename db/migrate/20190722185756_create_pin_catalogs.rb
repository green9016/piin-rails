class CreatePinCatalogs < ActiveRecord::Migration[5.2]
  def change
    create_table :pin_catalogs do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :banner, null: false
      t.string :icon, null: false
      t.string :color, null: false
      t.float :miles, null: false
      t.float :range, null: false
      t.integer :duration_in_days, null: false
      t.integer :daily_price_in_cents, null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :pin_catalogs, :discarded_at
  end
end
