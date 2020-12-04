class AddCheckedToPins < ActiveRecord::Migration[5.2]
  def change
    add_column :pins, :checked, :boolean, default: false, null: false
  end
end
