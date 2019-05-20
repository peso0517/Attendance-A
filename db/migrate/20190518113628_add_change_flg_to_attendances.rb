class AddChangeFlgToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_flg, :boolean, default: false
  end
end
