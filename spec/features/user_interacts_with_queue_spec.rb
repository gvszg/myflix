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

    within(:xpath, "//tr[contains(.,'#{wife.title}')]") do
      fill_in "queue_items[][position]", with: 3
    end

    within(:xpath, "//tr[contains(.,'#{with_you.title}')]") do
      fill_in "queue_items[][position]", with: 1
    end

    within(:xpath, "//tr[contains(.,'#{black_white.title}')]") do
      fill_in "queue_items[][position]", with: 2
    end

    click_button "Update Instant Queue"

    expect(find(:xpath, "//tr[contains(.,'#{wife.title}')]//input[@type='text']").value).to eq("3")
    expect(find(:xpath, "//tr[contains(.,'#{with_you.title}')]//input[@type='text']").value).to eq("1")
    expect(find(:xpath, "//tr[contains(.,'#{black_white.title}')]//input[@type='text']").value).to eq("2")
  end
end