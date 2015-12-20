require 'spec_helper'

feature "User registers", { js: true, vcr: true } do
  background { visit register_path }

  scenario "with valid user info and valid card" do  
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content("Thank you for registering with MyFlix. Please sign in.")
  end

  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid.")
  end

  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Your card number is incorrect.")
  end

  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content("Please check your payment information!")
  end

  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid.")
  end

  scenario "with invalid user info and declined card" do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Your card number is incorrect.")
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "joe@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Joe Smith"
  end

  def fill_in_valid_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "12 - December", from: "date_month"
    select "2018", from: "date_year"  
  end

  def fill_in_invalid_card
    fill_in "Credit Card Number", with: "5555"
    fill_in "Security Code", with: "123"
    select "12 - December", from: "date_month"
    select "2018", from: "date_year"  
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: "400000000000002"
    fill_in "Security Code", with: "123"
    select "12 - December", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "joe@example.com" 
  end
end