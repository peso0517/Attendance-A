class UsersController < ApplicationController
before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
before_action :correct_user,   only: [:edit, :update]
before_action :admin_user,     only: [:destroy, :edit_basic_info]
 
 include UsersHelper
 require 'csv'
  
  def index
    id = cookies[:user_id]
    @user = User.find(id)
    @users = User.paginate(page: params[:page]).where(admin: false)
    # binding.pry
  end

  def show
   #ユーザー情報を取得
   @user = User.find(params[:id])
  if current_user.admin || current_user.superior == true || current_user.id == @user.id 
   #表示用上長ユーザー情報を取得
   @superior_user = User.where(superior: true).where.not(id: current_user.id)
   #セレクトボックス用上長ユーザー情報
   @superior = User.where(superior: true)
   #上長に対する残業申請の有無
   @overtime_to_sp = Attendance.where(authority_user_id: @user.id, apply_state: 2)
   @overtime_apply = @overtime_to_sp.includes(:user)
   @overtime_applys = @overtime_apply.group_by{|i| i.user.id}

   #上長に対する勤怠変更申請の有無
   @attendance_change_to_sp = Attendance.where(edit_authority_user_id: @user.id, attendance_change_state: 2)
   @attendance_change =  @attendance_change_to_sp.includes(:user)
   #上長に対する勤怠変更申請の有無
   @attendance_change_applys = @attendance_change.group_by{|i| i.user.id}
   
   #１ヶ月勤怠申請の有無
   @one_month_edit_to_sp = OneMonthAttendance.where(one_month_authority_user_id: @user.id, one_month_apply_state: 2).order('one_month_apply_date')
#   @one_month_edit = @one_month_edit_to_sp.includes(:user)
   @one_month_applys = @one_month_edit_to_sp.group_by{|i| i.one_month_applying_user_id}
    
   if params[:first_day] == nil
      # params[:first_day]が存在しない(つまりデフォルト時) # ▼月初(今月の1日, 00:00:00)を取得します
      @first_day = Date.today.beginning_of_month
    else
      @first_day = params[:first_day].to_date
   end
   @last_day = @first_day.end_of_month
   
    #上長に対する１か月勤怠の申請の有無
    @one_month_apply = OneMonthAttendance.find_by(one_month_applying_user_id: @user.id,one_month_apply_date: @first_day)
    if !@one_month_apply.nil?
      @one_month_appled_user = User.find_by(id: @one_month_apply.one_month_authority_user_id)
    end
   #曜日表示用に使用する
   @youbi = %w(日 月 火 水 木 金 土)
          
   # 今月の初日から最終日の期間分を取得 
   (@first_day..@last_day).each do |days|
   # ない日付はインスタンスを生成して保存する
     if not @user.attendances.any? { |obj| obj.day == days }
      dates = Attendance.new(user_id: @user.id, day: days)
      dates.save
     end
   end 
   # 当月を昇順で取得し@daysへ代入
   @days = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order('day')
   #出勤日数表示
   @attendance_sum = @days.where.not(attendance_time: nil, leaving_time: nil).count
   #在社時間表示
    second = 0
    next_second = 0
    @total_time = 0
    @days.each do |d|
     if d.attendance_time.present? && d.leaving_time.present?
       if d.edit_next_check == 0
        second = second + times(d.attendance_time,d.leaving_time)
        @total_time = @total_time + second.to_i
       end
       if d.edit_next_check == 1
        next_second = next_second + next_times(d.attendance_time,d.leaving_time)
        @total_time = @total_time + next_second.to_i
       end
     end
   end
   else 
    flash[:warning] = "他ユーザーの情報を閲覧することができません！"
    redirect_to current_user
   end
  end
  
  #出社時間
  def attendance_time
    @user = User.find(params[:id])
    @attendance_time = @user.attendances.find_by(day: Date.current)
    @attendance_time.update_attributes(attendance_time: current_time,
                                       before_edit_attendance_time: current_time)
    flash[:info] = "出社登録完了しました！！"
    redirect_to @user
  end
  
  #退社時間
  def leaving_time
    @user = User.find(params[:id])
    @leaving_time = @user.attendances.find_by(day: Date.current)
    @leaving_time.update_attributes(leaving_time: current_time,
                                     before_edit_leaving_time: current_time)
    flash[:info] = "退社登録完了しました！！"
    redirect_to @user
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       log_in @user
       flash[:success]="ようこそ"
       redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "アカウントを更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def edit_basic_info
    if params[:id].nil?
      @user  = User.find(current_user.id)
    else
      @user  = User.find(params[:id])
    end
  end
  
  def update_basic_info
      @user = User.find(params[:id])
    if @user.update_attributes(users_basic_params)
        # binding.pry
      # 更新に成功した場合を扱う。
      flash[:success] = "基本情報を修正しました！！"
      id = cookies[:user_id]
      @user = User.find(id)
      redirect_to @user
    else
      render 'index'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました！！"
    redirect_to users_url
  end
  
  def csv_output
    @user = User.find(params[:id])
    date = params[:first_day].to_datetime
    output_first_day = date.beginning_of_month
    output_last_day = output_first_day.end_of_month
    @youbi = %w(日 月 火 水 木 金 土)
    
    @attendances = @user.attendances.where(day: output_first_day..output_last_day).order('day')
    respond_to do |format|
      format.csv do
        send_data render_to_string, filename: "#{@user.name}.csv", type: :csv
      end
    end
  end
  
  def csv_input
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    registered_count = import_users
    redirect_to users_url, notice: "#{registered_count}件登録しました"

  end
  
  def work_on_employee
    @user = User.find(params[:id])
    @work_on_list = Attendance.where(day: Date.today, leaving_time: nil).where.not(attendance_time: nil).order(user_id: "DESC")
  end

  private
    def import_users
      # 登録処理前のレコード数
      current_user_count = User.count
    #   users = []
    #   # windowsで作られたファイルに対応するので、encoding: "SJIS"を付けている
    #   CSV.foreach(params[:file].path, headers: true) do |row|
    #     users << User.new({id: row["id"], name: row["name"], email: row["email"] })
    #   end
    #   # importメソッドでバルクインサートできる
    #   User.import(users)
      # 何レコード登録できたかを返す
      User.count - current_user_count  
    #   binding.pry
    end
  
    def user_params
      params.require(:user).permit(:name,:email,:user_card_id ,:employee_number ,:password,
                                   :password_confirmation,:affiliation,
                                   :specified_work_time,:specified_end_time ,:basic_work_time)
    end
    
    def users_basic_params
      params.require(:user).permit(:name,:email,:user_card_id ,:employee_number ,:password,
                                   :affiliation,:specified_work_time,:specified_end_time ,:basic_work_time)
    end
                
    # beforeアクション

     # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
