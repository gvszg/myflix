class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user
      AppMailer.send_forgot_password(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:danger] = params[:email].blank? ? "Email can not be blank!" : "There is no user with the email in the system!"
      redirect_to forgot_password_path
    end
  end
end