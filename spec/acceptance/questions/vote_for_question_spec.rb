require_relative "../acceptance_helper"

feature "Vote for question", %(
In order to change rating of question
as a user
i want to be able to vote for question.
) do

  given(:user) { create(:user) }
  given(:user_non_author) { create(:user) }
  given!(:question_author) { create(:question, user: user) }
  given!(:question_non_author) { create(:question, user: user_non_author) }

  before {
    user.confirm
    user_non_author.confirm
  }

  describe "Author of question" do
    scenario "Authenticated user try to vote for question" do
      sign_in(user)
      visit question_path(question_author)

      within ".question_votement" do
        expect(page).to_not have_content "+"
        expect(page).to_not have_content "-"
      end
    end
  end

  describe "Non-author of question authenticated user" do

    before { sign_in(user) }

    scenario "vote for question", js: true do
      visit question_path(question_non_author)

      within ".question_votement" do
        expect(page).to have_content "+"
        expect(page).to have_content "0"
        expect(page).to have_content "-"
        click_on "+"
        expect(page).to have_content "1"
      end
    end

    scenario "unvote current question", js: true do
      visit question_path(question_non_author)

      within ".question_votement" do
        expect(page).to have_content "+"
        expect(page).to have_content "0"
        expect(page).to have_content "-"
        click_on "-"
        expect(page).to have_content "-1"
      end
    end

    scenario "can changes rating only by one vote", js: true do
      visit question_path(question_non_author)

      within ".question_votement" do
        expect(page).to have_content "+"
        expect(page).to have_content "0"
        expect(page).to have_content "-"
        click_on "+"
        expect(page).to have_content "1"
        expect(page).to_not have_content "+"
        expect(page).to have_content "-"
      end
    end
  end

  scenario "Non-authenticated user" do
    visit question_path(question_non_author)
    within ".question_votement" do
      expect(page).to_not have_content "+"
      expect(page).to have_content "0"
      expect(page).to_not have_content "-"
    end
  end
end
