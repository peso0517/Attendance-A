class AddEditAuthorityUserIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_authority_user_id, :integer
  end
end
