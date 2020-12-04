class ChangePhotoOnPosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :photo, :string, null: true
  end
end
