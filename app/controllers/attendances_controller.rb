class AttendancesController < ApplicationController
   before_action :logged_in_user
   include UsersHelper
   include AttendanceHelper

   
   
  def edit
   @user = User.find(params[:id])
      
   if current_user.admin || current_user.superior == true || current_user.id == @user.id 
   #上長ユーザー情報を取得
   @superior_user = User.where(superior: true).where.not(id: current_user.id) 
   
   
   if params[:first_day] == nil
      # params[:first_day]が存在しない(つまりデフォルト時) # ▼月初(今月の1日, 00:00:00)を取得します
      @first_day = Date.new(Date.today.year, Date.today.month)
   else
      @first_day = params[:first_day].to_date
   end
      @last_day = @first_day.end_of_month
      
      # 今月の初日から最終日の期間分を取得 
      (@first_day..@last_day).each do |days| #20/27
        
      # ない日付はインスタンスを生成して保存する
       if not @user.attendances.any? { |obj| obj.day == days } #23/26
        dates = Attendance.new(user_id: @user.id, day: days) 
        dates.save
       end #23/26
      end #20/27
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
    
  else 
    flash[:warning] = "他ユーザーの情報を閲覧することができません！"
    redirect_to current_user
  end
  end
 
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
      flash[:success] = '勤怠時間を更新しました。'
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
       if attendance.before_edit_attendance_time.blank? 
          attendance.update_attributes(before_edit_attendance_time: attendance.edit_attendance_time)
       end
       if attendance.before_edit_leaving_time.blank?
        attendance.update_attributes(before_edit_leaving_time: attendance.edit_leaving_time)
       end
       #申請された内容を更新する。
       attendance.update_attributes(item)
       attendance.update_attributes(change_flg: "false")
       #承認されたら、出社時間と退社時間を更新する。
       if attendance.attendance_change_state == "applied3"
        attendance.update_attributes(attendance_time: attendance.edit_attendance_time,leaving_time: attendance.edit_leaving_time)
       end
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
    elsif params[:check] == "0" && ((@overtime_apply.hour + @overtime_apply.min)) - (@user.specified_end_time.hour + @user.specified_end_time.min) < 0
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
end