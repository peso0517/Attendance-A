class AddEditNextCheckToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_next_check, :integer, default: 0, null: false
  end
end
