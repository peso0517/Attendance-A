class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(employee_number: params[:session][:employee_number])
    if user && user.authenticate(params[:session][:password])
        cookies[:user_id] = user.id
  #    if user.activated?
        log_in user
  #　    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
  #    else
   #     message  = "Account not activated. "
   #     message += "Check your email for the activation link."
    #    flash[:warning] = message
     #   redirect_to root_url
    else
      flash.now[:danger] = '社員番号かパスワードが間違っています'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end