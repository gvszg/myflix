require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "returns the videos in the reverse chronical order by created at" do
      tv_commedies = Category.create(name: 'TV Commedies')
      wife_1 = Video.create(title: "The Fierce Wife", description: "The Fierce Wife", category: tv_commedies, created_at: 1.day.ago)
      black_white_1 = Video.create(title: "Black and White", description: "Black and White", category: tv_commedies)
      expect(tv_commedies.recent_videos).to eq([black_white_1, wife_1])
    end

    it "returns all the videos if there are less than 6 videos" do
      tv_commedies = Category.create(name: 'TV Commedies')
      wife_1 = Video.create(title: "The Fierce Wife", description: "The Fierce Wife", category: tv_commedies, created_at: 1.day.ago)
      black_white_1 = Video.create(title: "Black and White", description: "Black and White", category: tv_commedies)
      expect(tv_commedies.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are more than 6 videos" do
      tv_commedies = Category.create(name: 'TV Commedies')
      7.times {wife_1 = Video.create(title: "The Fierce Wife", description: "The Fierce Wife", category: tv_commedies)}
      expect(tv_commedies.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      tv_commedies = Category.create(name: 'TV Commedies')
      7.times {Video.create(title: "The Fierce Wife", description: "The Fierce Wife", category: tv_commedies)}
      wife_1 = Video.create(title: "The Fierce Wife", description: "The Fierce Wife", category: tv_commedies, created_at: 1.day.ago)
      expect(tv_commedies.recent_videos).not_to include(wife_1) 
    end

    it "returns an empty array if the category has no any movie" do
      tv_commedies = Category.create(name: 'TV Commedies')
      expect(tv_commedies.recent_videos).to eq([])
    end
  end
end