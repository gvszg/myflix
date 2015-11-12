require 'spec_helper'

feature 'user signs in' do
  scenario 'with valid email and password' do
    joe = Fabricate(:user)
    sign_in(joe)
    visit sign_in_path
    expect(page).to have_content joe.username
  end
end