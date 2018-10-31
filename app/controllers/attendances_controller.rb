class AttendancesController < ApplicationController
   before_action :logged_in_user

   #createをattendance_timeに修正すれば登録はできる。
   def create
    @user = User.find(current_user.id)
    @attendance_time = @user.attendances.find_by(day: Date.current, user_id: @user.id)
    if @user.attendances.find_by(attendance_time_params).nil?
      @attendance_time.update_attributes(attendance_time_params: DateTime.new(DateTime.now.year,\
      DateTime.now.month, DateTime.now.day,DateTime.now.hour,DateTime.now.min,0))
      flash[:info] = "今日も１日頑張りましょう！！"
      redirect_to @user
    end
   end
   
  def attendance_time
  end
  
  def leaving_time
  end
  
end
 private
    def attendance_time_params
      params.require(:attendance).permit(:attendance_time)[:attendances]
    end
    
    