class User < ActiveRecord::Base
  has_secure_password
  has_many :queue_items, -> { order(:position) }
  has_many :reviews, -> { order("created_at DESC") }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  validates_presence_of :email, :password, :username
  validates_uniqueness_of :email

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follows?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

  def queue_items_quantity
    queue_items.count
  end

  def total_number_of_people_who_follow_me
    leading_relationships.count
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end