require 'spec_helper'

feature "User following" do
  scenario "user follows and unfollows someone" do
    category = Fabricate(:category, name: 'category')
    video = Fabricate(:video, category: category)
    joe = Fabricate(:user)
    review = Fabricate(:review, user: joe, video: video)
    sign_in
    click_video_on_home_page(video)
    click_link joe.username
    click_link 'Follow'
    expect(page).to have_content(joe.username)
    unfollow(joe)
  end

  def unfollow(user)
    within(:xpath, "//tr[contains(.,'#{user.username}')]") do
      find("a[data-method='delete']").click
    end
  end
end
