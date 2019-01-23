class AddSpecifiedEndTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :specified_end_time, :datetime
  end
end
