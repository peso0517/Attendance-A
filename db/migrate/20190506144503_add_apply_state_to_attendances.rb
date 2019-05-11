class AddApplyStateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :apply_state, :integer, default: 1, null: false
  end
end
