class AddPinCatalogToPins < ActiveRecord::Migration[5.2]
  def change
    add_reference :pins, :pin_catalog, foreign_key: true
  end
end
