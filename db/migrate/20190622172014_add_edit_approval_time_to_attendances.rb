class AddEditApprovalTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :latest_approval_date, :date
  end
end
