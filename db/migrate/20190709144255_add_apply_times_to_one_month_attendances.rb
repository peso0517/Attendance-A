class AddApplyTimesToOneMonthAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :one_month_attendances, :apply_times, :integer,default: 0
  end
end
