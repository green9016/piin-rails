class RemoveActiveFromFlags < ActiveRecord::Migration[5.2]
  def change
    remove_column :flags, :active, :boolean, default: false
  end
end
