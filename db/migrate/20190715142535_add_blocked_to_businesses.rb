class AddBlockedToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :blocked, :boolean, default: false, null: false, index: true
  end
end
