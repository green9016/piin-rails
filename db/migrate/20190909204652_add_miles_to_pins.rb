class AddMilesToPins < ActiveRecord::Migration[5.2]
  def change
    add_column :pins, :miles, :float, null: false, default: 0
  end
end
