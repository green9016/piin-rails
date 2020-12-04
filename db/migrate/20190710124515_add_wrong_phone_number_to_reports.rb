class AddWrongPhoneNumberToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :wrong_phone_number, :boolean, default: false
  end
end
