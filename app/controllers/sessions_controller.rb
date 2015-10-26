class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:warning] = "Welcome back, #{user.username}!"
      redirect_to home_path
    else
      flash.now[:danger] = "Invalid email or password!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:warning] = "You've logged out!"
    redirect_to root_path
  end
end