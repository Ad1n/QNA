require_relative "../acceptance_helper"

feature "User sign out", %(
In oder to leave user session
as User
I want to be able to sign out.
) do
  given(:user) { create(:user) }

  scenario "Signed in user try to sign out" do
    sign_in(user)
    click_on "Log out"
    expect(page).to have_content("Signed out successfully.")
  end

  scenario "Non-signed in user try to sign out" do
    expect(page).to_not have_selector(:button, "Log out")
  end
end
