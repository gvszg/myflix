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
end