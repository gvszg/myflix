class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if current_user
    @user = User.new   
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    if result.successful?
      flash[:success] = "Thank you for registering with MyFlix. Please sign in."
      redirect_to sign_in_path
    else
      flash.now[:danger] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :username)
  end
end