class Attendance < ApplicationRecord
  belongs_to :user
  #1:未申請 2:申請中 3:承認済み 4:否認
  #残業申請
  enum apply_state: {nothing:1, applying:2, applied:3, denial:4}
# 　勤怠編集
  enum attendance_change_state: {nothing1:1, applying2:2, applied3:3, denial4:4}
  
  class << self
    def localed_apply_state
      apply_states.keys.map do |s|
        [I18n.t("apply_state.article.#{s}"), s]
      end
    end
  end
  
end
