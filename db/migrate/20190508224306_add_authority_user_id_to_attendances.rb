class AddAuthorityUserIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :authority_user_id, :integer
  end
end
