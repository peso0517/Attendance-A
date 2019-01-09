class AttendancesController < ApplicationController
   before_action :logged_in_user
   include UsersHelper
   
   
  def edit
   @user = User.find(params[:id])
      
   if current_user.admin || current_user.id == @user.id

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
    i = 0
    @days.each do |d|
    if d.attendance_time.present? && d.leaving_time.present?
        second = 0
        second = times(d.attendance_time,d.leaving_time)
        @total_time = @total_time.to_i + second.to_i
        i = i + 1
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
  
  def attendance_update
      
  @user = User.find_by(id: params[:id])
    error_count = 0
    error_message = ""
    
      attendances_params.each do |id, item|
      attendance = Attendance.find(id)
      
      #出社時間と退社時間の両方の存在を確認
      if item["attendance_time"].blank? && item["leaving_time"].blank?
        
      # 当日以降の編集はadminユーザのみ
      elsif attendance.day > Date.current
        error_message = '明日以降の勤怠編集は出来ません。'
        error_count += 1
      
      #出社時間 > 退社時間ではないか
      elsif item["attendance_time"].to_s > item["leaving_time"].to_s
        error_message = '出社時間より退社時間が早い項目がありました'
        error_count += 1
      end
    end #eachの締め
    
    if error_count > 0
      flash[:warning] = error_message
    else
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        
        if item["attendance_time"].blank? && item["leaving_time"].blank?
          
        else
          attendance.update_attributes(item)
          flash[:success] = '勤怠時間を更新しました。'
        end
      end #eachの締め
    end
    redirect_to user_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
  end
  
 private
  
  def attendances_params
   params.permit(attendances: [:attendance_time, :leaving_time])[:attendances]
  end
  
end