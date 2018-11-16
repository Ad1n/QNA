require_relative "../acceptance_helper"

feature 'Create question', %(
  In order to get answer from community
  as an authenticated user
  i want to be able to create questions.
) do

  given(:user) { create(:user) }

  scenario "User be able to see errors in current page" do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    click_on "Create"

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body can't be blank")
  end

  scenario 'Authenticated user creates question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    click_on 'Create'
    expect(page).to have_content "Test question"
    expect(page).to have_content "Text text"
    expect(page).to have_content "Your question successfully created."
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end