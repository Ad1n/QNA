require "rails_helper"

feature "User sign up", %(
For do actions of authorized user
as user
I want to be able to sign up.
) do

  given(:user) { create(:user) }

  scenario "Non-signed up user try to sign up" do
    visit new_user_registration_path
    fill_in "Email", with: "testuser@test.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_button "Sign up"

    expect(page).to have_content("You have signed up successfully.")
  end

  scenario "Signed up user try to sign up" do
    visit new_user_registration_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.encrypted_password
    fill_in "Password confirmation", with: user.encrypted_password
    click_button "Sign up"

    expect(page).to have_content("1 error prohibited this user from being saved")
  end
end
