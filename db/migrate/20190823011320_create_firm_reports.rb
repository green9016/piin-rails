class CreateFirmReports < ActiveRecord::Migration[5.2]
  def change
    create_table :firm_reports do |t|
      t.integer :month
      t.integer :year
      t.integer :total_spent_cents
      t.integer :daily_spent_cents
      t.integer :total_likes
      t.integer :pins_purchased
      t.integer :people_reached
      t.belongs_to :firm, foreign_key: true, index: true

      t.timestamps
    end
  end
end
