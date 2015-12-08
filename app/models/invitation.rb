class Invitation < ActiveRecord::Base
  include Tokenable
  
  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_name, :recipient_email, :message

  def inviter_follow_user(user)
    inviter.follow(user)
    update_column(:token, nil)
  end
end