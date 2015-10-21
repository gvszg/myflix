require 'spec_helper'

describe Video do
  it "saves itself" do
    film = Video.new(title: 'Knight', description: 'A Knight', category_id: 1)
    film.save
  
    expect(Video.first.description).to eq('A Knight')
  end

  it "belonds to category" do
    tv = Category.create(name: 'TV Commedies')
    black_white = Video.create(title: "Black and White", description: "Black and White", category: tv)

    expect(black_white.category).to eq(tv)
  end

  it "does not save a video without a title" do
    video = Video.create(description: "The Fierce Wife")
    expect(Video.count).to eq(0)
  end

  it "does not save a video without a description" do
    video = Video.create(title: "The Fierce Wife")
    expect(Video.count).to eq(0)
  end
end