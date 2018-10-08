class AttendanceController < ApplicationController
 
 def index
   @users = User.where(activated: true).paginate(page: params[:page])
 end


  def show
    @user = User.find(params[:id])
    #redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
    
    day = Date.today

    @start_date = Date::new(day.year,day.month, 1)

    @end_date = Date::new(day.year,day.month, -1)

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
       log_in@user
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
end
