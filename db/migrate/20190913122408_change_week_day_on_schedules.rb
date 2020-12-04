class ChangeWeekDayOnSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :week_day, :week_days
    add_column :schedules, :week_days, :string, array: true, default: [], null: false
  end
end
