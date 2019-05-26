class AddEditAuthorityUserIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_authority_user_id, :integer
    add_column :attendances, :edit_attendance_time, :datetime
    add_column :attendances, :edit_leaving_time, :datetime
    add_column :attendances, :before_edit_attendance_time, :datetime
    add_column :attendances, :before_edit_leaving_time, :datetime
  end
end
