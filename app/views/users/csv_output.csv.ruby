require 'csv'

CSV.generate do |csv|
  column_names = ["日付","曜日","出社時間","退社時間","備考"]
  csv << column_names
  @attendances.each do |attendance|
    column_values = [
      attendance.day,
      @youbi[attendance.day.wday],
      if attendance.attendance_time.present?
      attendance.attendance_time.to_s(:time)
      end,
      if attendance.leaving_time.present?
      attendance.leaving_time.to_s(:time)
      end,
      attendance.remarks
    ]
    csv << column_values
  end
end