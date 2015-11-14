require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorder videos in the queue" do
    comedies = Fabricate(:category, name: "Comedies")
    wife = Fabricate(:video, title: "The Fierce Wife", category: comedies)
    with_you = Fabricate(:video, title: "In Time With You", category: comedies)
    black_white = Fabricate(:video, title: "Black and White", category: comedies)
    
    sign_in

    add_video_to_queue(wife)
    expect_video_to_be_in_queue(wife)

    visit video_path(wife)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(with_you)
    add_video_to_queue(black_white)

    set_video_position(wife, 3)
    set_video_position(with_you, 1)
    set_video_position(black_white, 2)
    update_queue
    
    expect_video_position(wife, 3)
    expect_video_position(with_you, 1)
    expect_video_position(black_white, 2)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content(link_text)  
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end