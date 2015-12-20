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

    if @user.valid?      
      charge = StripeWrapper::Charge.create(
        amount: 999,
        source: params[:stripeToken],
        description: "Sign up charge for #{@user.email}"
      )

      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.delay.send_welcome_email(@user)
        flash[:warning] = "You've registered!"
        redirect_to sign_in_path
      else
        flash[:danger] = charge.error_message
        render :new
      end
    else
      flash.now[:danger] = "Please check your payment information!"
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

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token]) 
      @user.follow(invitation.inviter)
      invitation.inviter_follow_user(@user)    
    end   
  end
end