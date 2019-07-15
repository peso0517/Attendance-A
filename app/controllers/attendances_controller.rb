class AttendancesController < ApplicationController
   before_action :logged_in_user
   include UsersHelper
   include AttendanceHelper
   
  def edit
   @user = User.find(params[:id])
      
  # / if current_user.admin || current_user.superior == true || current_user.id == @user.id 
   #上長ユーザー情報を取得
   @superior_user = User.where(superior: true).where.not(id: current_user.id) 
    
    #日付取得
    @first_day = params[:first_day].to_date
    @last_day = @first_day.end_of_month
    # 当月を昇順で取得し@daysへ代入
    @days = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order('day')
    #在社時間表示
    @days.each do |d|
      if d.attendance_time.present? && d.leaving_time.present?
        second = 0
        second = times(d.attendance_time,d.leaving_time)
        @total_time = @total_time.to_i + second.to_i
      end
    end
    
    #出勤日数表示
    @attendance_sum = @days.where.not(attendance_time: nil, leaving_time: nil).count
    
    #曜日表示用に使用する
    @youbi = %w(日 月 火 水 木 金 土)
    
  # else 
  #   flash[:warning] = "他ユーザーの情報を閲覧することができません！"
  #   redirect_to current_user
  end
  # //= require turbolinks
 
  #勤怠変更申請
  def attendance_update
    @user = User.find_by(id: params[:id])
    if attendances_invalid?
       attendances_edit_apply_params.each do |id, item|
         attendance = Attendance.find(id)
         attendance.update_attributes(item)
         if item["edit_authority_user_id"].present?
          attendance.update_attributes(attendance_change_state: "applying2")
         end
       end
      flash[:success] = '勤怠変更を申請しました。'
      redirect_to user_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
    else
      flash[:warning] = '不正な入力があります。再度申請してください。'
      redirect_to edit_attendance_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
    end
  end
  
  #勤怠変更承認
  def attendance_edit_approval
   attendance_edit_approval_params.each do |id, item|
    attendance = Attendance.find(id)
      if item[:change_flg] === "true"
       #申請された内容を更新する。
       attendance.update_attributes(item)
       attendance.update_attributes(change_flg: "false")
       #承認されたら、出社時間と退社時間を更新する。
       if attendance.attendance_change_state == "applied3"
        attendance.update_attributes(attendance_time: attendance.edit_attendance_time,
                                     leaving_time: attendance.edit_leaving_time,
                                     latest_approval_date: Date.today)
       end
       
       #最初の登録時間が入ってなければ
       # if attendance.before_edit_attendance_time.blank?
       #   attendance.update_attributes(before_edit_attendance_time: attendance.before_edit_attendance_time)
       # end
       # #
       # if attendance.before_edit_attendance_time.blank?
       #   attendance.update_attributes(before_edit_attendance_time: attendance.before_edit_attendance_time)
       # end
        flash[:info] = "変更しました！"
      end
   end
      redirect_to current_user
  end
  
  #１日分の残業申請
  def one_overtime_apply
    @user = User.find(params[:id])
    @one_overtime_apply = @user.attendances.find_by(day: params[:day])
    #残業予定時間
    @overtime_apply = params[:overtime_plan].in_time_zone
    if  params[:overtime_plan].blank? || params[:business_process].blank? || params[:authority_user_id].blank?
     flash[:danger] = "未入力項目がありました。再度申請してください。"
    elsif params[:check] == "0" && (@overtime_apply.hour + @overtime_apply.min) - (@user.designated_work_end_time.hour + @user.designated_work_end_time.min) < 0
     flash[:danger] = "不正な時間入力がありました。再度申請してください。"
    else
     @one_overtime_apply.update_attributes(overtime_plan: params[:overtime_plan],
                                           business_process: params[:business_process],
                                           check: params[:check],
                                           apply_state: 2,
                                           authority_user_id: params[:authority_user_id])
     flash[:info] = "残業申請しました！"
    end
   redirect_to @user
  end
  #残業承認
  def one_overtime_approval
      one_overtime_approval_params.each do |id, item|
      attendance = Attendance.find(id)
       if item[:change_flg] === "true"
        attendance.update_attributes(item)
        attendance.update_attributes(change_flg: "false")
        flash[:info] = "変更しました！"
       else
       end
      end
      redirect_to current_user
  end
  
  #１ヶ月分勤怠申請
  def one_month_apply
   if params[:apply_times] == "1"
     if params[:one_month_authority_user_id].blank?
       flash[:danger] = "1ヶ月分の勤怠申請を行う場合、所属長を選択してください。"
     else
       @user = User.find_by(id: params[:one_month_applying_user_id])
       @first_day = params[:first_day].to_date
       # ない日付はインスタンスを生成して保存する
       if not OneMonthAttendance.any? { |obj| obj.one_month_apply_date == @first_day && obj.one_month_applying_user_id == @user.id}
         one_month_apply = OneMonthAttendance.create(one_month_applying_user_id: @user.id, one_month_apply_date: @first_day)
       end
        @one_month_apply = OneMonthAttendance.find_by(one_month_applying_user_id: @user.id,one_month_apply_date: @first_day)
        @one_month_apply.update_attributes(one_month_apply_state: params[:one_month_apply_state],
                                           one_month_authority_user_id: params[:one_month_authority_user_id],
                                           apply_times: 2)
                             
        flash[:info] = "#{@first_day.year}年#{@first_day.month}月分の勤怠申請しました！！"
        # redirect_to current_user
     end
    
   else 
     if params[:one_month_attendance][:one_month_authority_user_id].blank?
         flash[:danger] = "1ヶ月分の勤怠申請を行う場合、所属長を選択してください。"
     else
       @user = User.find_by(id: params[:one_month_applying_user_id])
       @first_day = params[:first_day].to_date
       # ない日付はインスタンスを生成して保存する
       if not OneMonthAttendance.any? { |obj| obj.one_month_apply_date == @first_day && obj.one_month_applying_user_id == @user.id}
         one_month_apply = OneMonthAttendance.create(one_month_applying_user_id: @user.id, one_month_apply_date: @first_day)
       end
        @one_month_apply = OneMonthAttendance.find_by(one_month_applying_user_id: @user.id,one_month_apply_date: @first_day)
        @one_month_apply.update_attributes(one_month_apply_state: params[:one_month_apply_state],
                                           one_month_authority_user_id: params[:one_month_attendance][:one_month_authority_user_id])
                             
        flash[:info] = "#{@first_day.year}年#{@first_day.month}月分の勤怠申請しました！！"
        
     end

   end
       redirect_to current_user
  end
  
   #1ヶ月勤怠承認
  def one_month_attendance_approval
   one_month_apply_params.each do |id, item|
    one_month_attendance = OneMonthAttendance.find(id)
      if item[:approval_flg] === "true"
       #申請された内容を更新する。
       one_month_attendance.update_attributes(item)
       one_month_attendance.update_attributes(approval_flg: "false")
        flash[:info] = "変更しました！"
      end
   end
      redirect_to current_user
      
  end
  
  def attendance_log
   @user = User.find(params[:id])
   if current_user.admin || current_user.superior == true || current_user.id == @user.id 

    #日付取得
    @first_day = params[:first_day].to_date
    @last_day = @first_day.end_of_month
    # 当月を昇順で取得し@daysへ代入
    @days = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order('day')

    #曜日表示用に使用する
    @youbi = %w(日 月 火 水 木 金 土)
    
  else 
    flash[:warning] = "他ユーザーの情報を閲覧することができません！"
    redirect_to current_user
  end
 end
  
  def log_search
   @year = params[:year].to_i
   @month = params[:month].to_i
   @day = Date.new(@year,@month,1)
   @last_day = @day.end_of_month
   @user = User.find(params[:id])
   @days = Attendance.where(user_id: @user.id).where('day >= ? and day <= ?', @day, @last_day).order('day')
   @attendance = @days.where(attendance_change_state: 3)
  end

 private
  
  def attendances_edit_apply_params
   params.permit(attendances: [:edit_attendance_time, :edit_leaving_time, :edit_next_check, :remarks, :edit_authority_user_id])[:attendances]
  end
  
  def one_overtime_approval_params
   params.permit(attendances: [:apply_state,:change_flg])[:attendances]
  end
  
  def attendance_edit_approval_params
   params.permit(attendances: [:attendance_change_state,:change_flg])[:attendances]
  end
  
  #１ヶ月勤怠承認
  def one_month_apply_params
   params.permit(one_month_attendances: [:one_month_apply_state,:approval_flg])[:one_month_attendances]
  end
  
end