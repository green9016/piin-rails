class AddStatusToPinCatalog < ActiveRecord::Migration[5.2]
  def change
    add_column :pin_catalogs, :status, :integer, default: 0
  end
end
