class BasesController < ApplicationController
before_action :admin_user,     only: [:index,:create,:edit_base_info,:update_base_info,:destroy]


  def index
    id = cookies[:user_id]
    @user = User.find(id)
    if current_user.admin && current_user?(@user) || logged_in?
      @bases = Base.paginate(page: params[:page])
    else 
     flash[:warning] = "管理者以外は、拠点情報を閲覧することができません！"
　　 redirect_to current_user
   end
  end
  
#   def new
#     @base = Base.new
#   end
  
  def create
    @base = Base.create(base_new_params)
    flash[:success]="拠点追加しました。"
    redirect_to bases_path
  end
  
  def edit
  end
  
  def edit_base_info
    # @user = User.find(params[:id])
    @base = Base.find(params[:id])
  end
  
  def update_base_info
    # @user = User.find(params[:id])
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を編集しました"
      redirect_to bases_path
    else
      render bases_path
    end
  end

  def destroy
    Base.find(params[:id]).destroy
    flash[:success] = "拠点情報を削除しました！！"
    redirect_to bases_path
  end

  private    
    def base_new_params
      params.permit(:base_name,:base_type)
    end
  
    
    def base_params
      params.require(:base).permit(:base_name,:base_type)
    end
    
  # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
