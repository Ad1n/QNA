require_relative "../acceptance_helper"

feature "Vote for answer", %(
In order to change rating of answer
as a user
i want to be able to vote for answer.
) do

  given(:user) { create(:user) }
  given(:user_non_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:answer_author) { create(:answer, question: question, user: user) }
  given(:answer_non_author) { create(:answer, question: question, user: user_non_author) }

  before {
    user.confirm
    user_non_author.confirm
  }

  describe "Author of answer" do

    before { answer_author }

    scenario "Authenticated user try to vote for answer" do
      sign_in(user)
      visit question_path(question)

      within ".answer_votement" do
        expect(page).to_not have_content "+"
        expect(page).to_not have_content "-"
      end
    end
  end

  describe "Non-author of answer authenticated user" do

    before {
      sign_in(user)
      answer_non_author
    }

    scenario "vote for answer", js: true do
      visit question_path(question)

      within ".answer_votement" do
        expect(page).to have_content "+"
        expect(page).to have_content "0"
        expect(page).to have_content "-"
        click_on "+"
        expect(page).to have_content "1"
      end
    end

    scenario "unvote current answer", js: true do
      visit question_path(question)

      within ".answer_votement" do
        expect(page).to have_content "+"
        expect(page).to have_content "0"
        expect(page).to have_content "-"
        click_on "-"
        expect(page).to have_content "-1"
      end
    end

    scenario "can changes rating only by one vote", js: true do
      visit question_path(question)

      within ".answer_votement" do
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

  describe "Non-authenticated user" do

    before { answer_non_author }

    scenario "try to vote for answer" do
      visit question_path(question)
      within ".answer_votement" do
        expect(page).to_not have_content "+"
        expect(page).to have_content "0"
        expect(page).to_not have_content "-"
      end
    end
  end
end
