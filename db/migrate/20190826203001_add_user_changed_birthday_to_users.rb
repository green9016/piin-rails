class AddUserChangedBirthdayToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_changed_birthday, :boolean, null: false, default: false
  end
end
