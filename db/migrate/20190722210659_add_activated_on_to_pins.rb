class AddActivatedOnToPins < ActiveRecord::Migration[5.2]
  def change
    add_column :pins, :activated_on, :datetime
  end
end
