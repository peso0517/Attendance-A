class AddApprovalFlgToOneMonthAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :one_month_attendances, :approval_flg, :boolean,  default: false
  end
end
