require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorder videos in the queue" do
    comedies = Fabricate(:category, name: "Comedies")
    wife = Fabricate(:video, title: "The Fierce Wife", category: comedies)
    with_you = Fabricate(:video, title: "In Time With You", category: comedies)
    black_white = Fabricate(:video, title: "Black and White", category: comedies)
    
    sign_in
    find("a[href='/videos/#{wife.id}']").click
    expect(page).to have_content(wife.title)

    click_link "+ My Queue"
    expect(page).to have_content(wife.title)

    visit video_path(wife)
    expect(page).not_to have_content("+ My Queue")

    visit home_path
    find("a[href='/videos/#{with_you.id}']").click
    click_link "+ My Queue"
    visit home_path
    find("a[href='/videos/#{black_white.id}']").click
    click_link "+ My Queue"

    fill_in "video_#{wife.id}", with: 3
    fill_in "video_#{with_you.id}", with: 1
    fill_in "video_#{black_white.id}", with: 2

    click_button "Update Instant Queue"

    expect(find("#video_#{with_you.id}").value).to eq("1")
    expect(find("#video_#{black_white.id}").value).to eq("2")
    expect(find("#video_#{wife.id}").value).to eq("3")
  end
end