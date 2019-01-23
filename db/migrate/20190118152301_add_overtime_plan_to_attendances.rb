class AddOvertimePlanToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_plan, :datetime
  end
end
