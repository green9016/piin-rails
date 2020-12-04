class ChangePostDefaultStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :status, :integer, default: 0, null: false
  end
end
