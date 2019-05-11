class Attendance < ApplicationRecord
  belongs_to :user
  #1:未申請 2:申請中 3:承認済み 4:否認
  enum apply_state:{nothing:1, applying:2, applied:3, denial:4}
  
  
end
