class AddUserCardIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_card_id, :string
  end
end
