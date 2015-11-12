require 'spec_helper'

feature 'user signs in' do
  scenario 'with valid email and password' do
    joe = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", with: joe.email
    fill_in "Password", with: joe.password
    click_button "Sign in"
    expect(page).to have_content joe.username
  end
end