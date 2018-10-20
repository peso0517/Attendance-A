class AttendancesController < ApplicationController
  
  def index
   @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
      require "date"
      @user = User.find(params[:id])
      #redirect_to root_url and return unless @user.activated?
      @microposts = @user.microposts.paginate(page: params[:page])
      #日付関連  #試作
    if params[:first_day] == nil
      # params[:piyo]が存在しない(つまりデフォルト時)
      # ▼月初(今月の1日, 00:00:00)を取得します
       @first_day = Date.new(Date.today.year, Date.today.month)
    else
      # ▼params[:piyo]が存在する(つまり切り替えボタン押下時)
      #  paramsの中身は"文字列"で送られてくるので注意
      #  文字列を時間の型に直すときはparseメソッドを使うか、
       @first_day = Date.parse(params[:first_day])
      #  もしくはto_datetimeメソッドとかで型を変える
      #  @first_day = params[:piyo].to_date
    end
       @last_day = @first_day.end_of_month
      # 今月の初日から最終日の期間分を取得 
      (@first_day..@last_day).each do |days|
      # 曜日表示用に使用する
       @youbi = %w[日 月 火 水 木 金 土]
       
       if @attendance.nil?
       @attendance = Attendance.new
       end
    end
  end
  
  def attend
       @user = User.find(params[:id])
    if @attendance.nil?
       @attendance = Attendance.new(attendance_time: Time.now)
    end
    if @attendance.save
       flash[:success]="出社時間を登録しました！！"
       redirect_to @user
    else
      render 'users/show'
    end
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       #@user.send_activation_email
       #flash[:info] = "Please check your email to activate your account."
       #redirect_to root_url
       log_in @user
       flash[:success]="ようこそ、勤怠管理システムへ"
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
  end
  
  def update_basic_info
      @user = User.find(1)
    if @user.update_attributes(users_basic_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "基本情報を修正しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,:affiliation)
    end
    
    def users_basic_params
      params.require(:user).permit(:specified_work_time, :basic_work_time)
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