class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token=nil)
    if @user.valid?    
      charge = StripeWrapper::Charge.create(
        amount: 999,
        source: stripe_token,
        description: "Sign up charge for #{@user.email}"
      )

      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success        
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status == :failed
      @error_message = "Please check your payment information!"
    end
    self
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token) 
      @user.follow(invitation.inviter)
      invitation.inviter_follow_user(@user)    
    end   
  end
end