require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe ".search_by_title" do
    it "returns an empty array if there is no match" do
      wife = Video.create(title: "The Fierce Wife", description: "The Fierce Wife")
      black_white = Video.create(title: "Black and White", description: "Black and White")
      
      expect(Video.search_by_title("Other movies")).to eq([])
    end
    
    it "returns an array of one video for an exact match" do
      wife = Video.create(title: "The Fierce Wife", description: "The Fierce Wife")
      black_white = Video.create(title: "Black and White", description: "Black and White")
      
      expect(Video.search_by_title("The Fierce Wife")).to eq([wife])
    end
    
    it "returns an array of one video for a partial match" do
      wife = Video.create(title: "The Fierce Wife", description: "The Fierce Wife")
      black_white = Video.create(title: "Black and White", description: "Black and White")
      
      expect(Video.search_by_title("Fierce Wi")).to eq([wife])
    end

    it "returns an array of all matches ordered by created_at" do
      wife = Video.create(title: "The Fierce Wife", description: "The Fierce Wife")
      black_white = Video.create(title: "Black and White", description: "Black and White")
      with_you = Video.create(title: "In Time With You", description: "In Time With You")

      expect(Video.search_by_title("Wi")).to eq([with_you, wife])
    end

    it "returns an empty array for a search with an empty string" do
      with_you = Video.create(title: "In Time With You", description: "In Time With You")

      expect(Video.search_by_title("")).to eq([])
    end
  end
end

