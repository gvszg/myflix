class ResetPasswordsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])

    if user
      @token = user.token
    else
      redirect_to invalid_token_path
    end
  end

  def create
    user = User.find_by(token: params[:token])
    
    if user
      user_rest_password(user)
    else
      redirect_to invalid_token_path
    end
  end

  private

  def user_rest_password(user)
    if params[:password].present?
      user.update(password: params[:password])
      user.clear_token
      flash[:success] = "Your password has been changed! Please sign in!"
      redirect_to sign_in_path
    else
      flash[:danger] = "Password cannot be blank!"
      redirect_to reset_password_path(user.token)
    end
  end
end