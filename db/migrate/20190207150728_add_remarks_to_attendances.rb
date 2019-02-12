class AddRemarksToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :remarks, :string
  end
end
