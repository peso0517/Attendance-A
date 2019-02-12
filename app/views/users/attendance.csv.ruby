require 'csv'

CSV.generate do |csv|
  column_names = %w(day attendance_time leaving_time remarks)
  csv << column_names
  @attendances.each do |attendance|
    column_values = [
      attendance.day,
      attendance.attendance_time,
      attendance.leaving_time,
      attendance.remarks
    ]
    csv << column_values
  end
end