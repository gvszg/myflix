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

    find("input[data-video-id = '#{wife.id}']").set(3)
    find("input[data-video-id = '#{with_you.id}']").set(1)
    find("input[data-video-id = '#{black_white.id}']").set(2)

    click_button "Update Instant Queue"

    expect(find("input[data-video-id='#{wife.id}']").value).to eq("3")
    expect(find("input[data-video-id='#{with_you.id}']").value).to eq("1")
    expect(find("input[data-video-id='#{black_white.id}']").value).to eq("2")
  end
end