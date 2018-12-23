require_relative "../acceptance_helper"

feature 'Question editing', %(
  In order to fix mistake
  As author of question
  I want to be able to edit my question
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  given(:user2) { create(:user) }
  given!(:question2) { create(:question, user: user2) }

  before {
    user.confirm
    user2.confirm
  }

  scenario "Non-authenticated user try to edit question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe "Authenticated user" do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "as author sees link Edit" do
      within ".question" do
        expect(page).to have_link "Edit question"
      end
    end

    scenario "as author try to edit his question", js: true do
      click_on "Edit question"
      within ".question" do
        fill_in "question_title", with: "Edited title"
        fill_in "question_body", with: "Edited body"
        click_on "Save"

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content "Edited title"
        expect(page).to have_content "Edited body"
      end
    end

    scenario "as non-author of question try to edit question", js: true do
      visit question_path(question2)

      within ".question" do
        expect(page).to_not have_link "Edit question"
        expect(page).to have_content(question2.body)
        expect(page).to have_content(question2.title)
      end
    end
  end
end

