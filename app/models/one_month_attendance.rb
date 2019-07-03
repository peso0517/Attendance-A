class OneMonthAttendance < ApplicationRecord
    
    #1月分勤怠申請
  enum one_month_apply_state: {nothing:1, applying:2, applied:3, denial:4}
  
  class << self
    def localed_apply_state
      one_month_apply_states.keys.map do |s|
        [I18n.t("one_month_apply_state.article.#{s}"), s]
      end
    end
  end
end
