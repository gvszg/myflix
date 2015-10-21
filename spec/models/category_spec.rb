require 'spec_helper'

describe Category do
  it "saves itself" do
    commedies = Category.new(name: "TV Commedies")
    commedies.save

    expect(Category.first).to eq(commedies) 
  end

  it "has many videos" do
    commedies = Category.create(name: "TV Commedies")
    with_you = Video.create(title: "In Time With You", description: "In Time With You", category: commedies)
    black_white = Video.create(title: "Black and White", description: "Black and White", category: commedies)

    expect(commedies.videos).to include(black_white, with_you )
  end
end