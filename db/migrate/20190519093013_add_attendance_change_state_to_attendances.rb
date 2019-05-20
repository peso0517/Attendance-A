class AddAttendanceChangeStateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_change_state, :integer, default: 1, null: false
  end
end
