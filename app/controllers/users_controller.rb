class UsersController < ApplicationController
before_action :logged_in_user, only: [:index, :show, :edit, :attend, :update, :destroy]
before_action :correct_user,   only: [:edit, :update]
before_action :admin_user,     only: [:destroy, :update_basic_info, :edit_basic_info]


  
  def index
   @users = User.where(activated: true).paginate(page: params[:page])
  end

   def show
      @user = User.find(params[:id])
      @attendance = Attendance.where(user_id: @user_id)
      #redirect_to root_url and return unless @user.activated?
      @microposts = @user.microposts.paginate(page: params[:page])
      
    if params[:first_day] == nil
       # params[:first_day]が存在しない(つまりデフォルト時) # ▼月初(今月の1日, 00:00:00)を取得します
        @first_day = Date.new(Date.today.year, Date.today.month)
    else
      # ▼params[:piyo]が存在する(つまり切り替えボタン押下時)
      #  paramsの中身は"文字列"で送られてくるので注意
        @first_day = Date.parse(params[:first_day])
      #  もしくはto_datetimeメソッドとかで型を変える
         #@first_day = params[:first_day].to_date
    end
       @last_day = @first_day.end_of_month
      # 今月の初日から最終日の期間分を取得 
      (@first_day..@last_day).each do |days|
        
      if not @user.attendances.any? { |obj| obj.day == days }
        # ない日付はインスタンスを生成して保存する
        dates = Attendance.new(user_id: @user.id, day: days)
        dates.save
      end
      
      # 当月を昇順で取得し@daysへ代入
      #@days = @user.attendances.where('day >= ? and day <= ?', \
      #@first_day, @last_day).order('day')

      # 曜日表示用に使用する
       @youbi = %w(日 月 火 水 木 金 土)
       
    end
   end
  
  def attendance_time
    @user = User.find(current_user.id)
    @attendance_time = @user.attendances.find_by(day: Date.current, user_id: @user.id)
    if @user.attendances.find_by(attendance_time: Time.current).nil?
    @attendance_time.update_attributes(attendance_time_params: DateTime.new(DateTime.now.year,\
    DateTime.now.month, DateTime.now.day,DateTime.now.hour,DateTime.now.min,0))
    flash[:info] = "今日も１日頑張りましょう！！"
    redirect_to @user
  end
    
  end
  
  def leaving_time
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