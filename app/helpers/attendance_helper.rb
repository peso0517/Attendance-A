module AttendanceHelper
  
 def attendances_invalid?
  attendances_edit = true
   attendances_edit_apply_params.each do |id, item|
    if item[:edit_attendance_time].blank? && item[:edit_leaving_time].blank?
      next
    elsif item[:edit_attendance_time].blank? || item[:edit_leaving_time].blank?
      attendances_edit = false
      break
    elsif (item[:edit_attendance_time] > item[:edit_leaving_time]) && item[:edit_next_check] == "0"
      attendances_edit = false
      break
    elsif item[:edit_authority_user_id].blank?
      attendances_edit = false
      break
    elsif item[:edit_authority_user_id].present? && item[:edit_attendance_time].blank? && item[:edit_leaving_time].blank?
      attendances_edit = false
      break
    end
   end
   return attendances_edit 
 end
 
 def current_time
  Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
    )
 end
end
