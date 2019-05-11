class AddCheckToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :check, :integer, default: 0, null: false
  end
end
