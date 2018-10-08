class AddSpecifiedWorkTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :specified_work_time, :datetime
  end
end
