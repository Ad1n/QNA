require_relative "../acceptance_helper"

feature "Authorizes with app", %(
  In order to have other variants for sign up
  As user
  I'd like to be able to authorize with other app
) do

  context "without email" do

    before {
      clear_emails
    }

    scenario "can sign up and sign in user with GitHub account" do

      visit new_user_registration_path
      mock_auth_hash_github
      click_on "Sign in with GitHub"

      fill_in "user[email]", with: "test_git@user.com"
      fill_in "user[password]", with: "12345678"
      fill_in "user[password_confirmation]", with: "12345678"
      within ".actions" do
        click_on "Sign up"
      end

      open_email('test_git@user.com')
      current_email.click_link "Confirm my account"

      expect(page).to have_content("Your email address has been successfully confirmed")

      click_link "Sign in with GitHub"
      expect(page).to have_content("test_git@user.com")
      expect(page).to have_content("Log out")
      expect(page).to have_content "Successfully authenticated from GitHub account."
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_registration_path
      expect(page).to have_content("Sign in with GitHub")
      click_link "Sign in with GitHub"
      expect(page).to have_content('Could not authenticate you from GitHub because "Invalid credentials".')
    end

  end

  context "with email" do
    it "can sign up and sign in user with VK account" do
      clear_emails

      visit new_user_registration_path
      expect(page).to have_content("Sign in with Vkontakte")
      mock_auth_hash_vk
      click_link "Sign in with Vkontakte"
      open_email('test_shevtsovav@bk.ru')
      current_email.click_link "Confirm my account"

      expect(page).to have_content("Your email address has been successfully confirmed")
      click_link "Sign in with Vkontakte"

      expect(page).to have_content("test_shevtsovav@bk.ru")
      expect(page).to have_content("Log out")
      expect(page).to have_content "Successfully authenticated from Vkontakte account."
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit new_user_registration_path
      expect(page).to have_content("Sign in with Vkontakte")
      click_link "Sign in with Vkontakte"
      expect(page).to have_content('Could not authenticate you from Vkontakte because "Invalid credentials".')
    end
  end

end
