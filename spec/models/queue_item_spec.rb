require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "returns the title of associated video" do
      hi = Fabricate(:video, title: "Hi")
      queue_item = Fabricate(:queue_item, video: hi)
      expect(queue_item.video_title).to eq("Hi")
    end
  end

  describe "#rating" do
    it "returns rating from the review when the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 5)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(5)
    end

    it "returns nil when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category's name of video" do
      movie = Fabricate(:category, name: "Movie")
      video = Fabricate(:video, category: movie)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Movie")  
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      movie = Fabricate(:category, name: "Movie")
      video = Fabricate(:video, category: movie)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(movie)
    end
  end
end