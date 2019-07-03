class CreateOneMonthAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :one_month_attendances do |t|
      t.integer :one_month_apply_state
      t.date :one_month_apply_date
      t.integer :one_month_authority_user_id
      t.integer :one_month_applying_user_id

      t.timestamps
    end
  end
end
