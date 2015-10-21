require 'spec_helper'

describe Video do
  it "saves itself" do
    film = Video.new(description: 'A Knight')
    film.save
  
    expect(Video.first.description).to eq('A Knight')
  end
end