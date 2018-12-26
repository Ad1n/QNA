require_relative "../acceptance_helper"

feature 'Create question', %(
  In order to get answer from community
  as an authenticated user
  i want to be able to create questions.
) do

  given(:user) { create(:user) }

  before {
    user.confirm
  }

  scenario "User be able to see errors in current page" do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    click_on "Create"

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body can't be blank")
  end

  scenario 'Authenticated user creates question', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    click_link "Do not add file"

    click_on 'Create'
    expect(page).to have_content "Test question"
    expect(page).to have_content "Text text"
    expect(page).to have_content "Your question successfully created."
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    expect(page).to_not have_content "Ask question"
  end

  context "Multiple sessions" do
    scenario "Question appears on another question's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Text text'
        click_link "Do not add file"

        click_on 'Create'
        expect(page).to have_content "Test question"
        expect(page).to have_content "Text text"
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "Test question"
        expect(page).to have_content "Text text"
      end

    end
  end
end