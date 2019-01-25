require_relative "../acceptance_helper"

feature 'Answer editing', %(
  In order to fix mistake
  As author of answer
  I want to be able to edit my answer
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given(:user2) { create(:user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  before {
    user.confirm
    user2.confirm
  }

  scenario "Non-authenticated user try to edit answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe "Authenticated user" do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "Sees link Edit" do
      within ".answers" do
        expect(page).to have_link "Edit"
      end
    end

    scenario "Try to edit his answer", js: true do
      click_on "Edit"
      within ".answers" do
        fill_in "Answer", with: "Edited answer"

        click_on "Save"

        expect(page).to_not have_content answer.body
        expect(page).to have_content "Edited answer"
      end
    end

    scenario "Non-author of answer try to edit answer", js: true do
      visit question_path(question)

      within ".answers" do
        expect(page).to have_link('Edit', count: 1)
        expect(page).to have_content(answer2.body)
        expect(page).to have_content(answer.body)

        click_on "Edit"
        fill_in "Answer", with: "Edited answer"
        click_on "Save"

        expect(page).to have_content(answer2.body)
        expect(page).to_not have_content(answer.body)
        expect(page).to have_content("Edited answer")
      end
    end

  end

end
