require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:email)}
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order(:position) }

  describe "#queued_video" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_truthy
    end

    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_falsey
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      joe = Fabricate(:user)
      emma = Fabricate(:user)
      Fabricate(:relationship, leader: emma, follower: joe)
      expect(joe.follows?(emma)).to be_truthy
    end

    it "returns false if the user does not have a following relationship with another user" do
      joe = Fabricate(:user)
      emma = Fabricate(:user)
      Fabricate(:relationship, leader: joe, follower: emma)
      expect(joe.follows?(emma)).to be_falsey
    end
  end

  describe "#follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be_truthy   
    end

    it "does not follow one self" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be_falsey
    end
  end
end