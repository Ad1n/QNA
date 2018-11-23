require_relative "../acceptance_helper"

feature "choose best answer for current question", %(
In order to help with finding best solution for question
as a author of question
i want to be able to choose best answer for this question.
) do

  given(:user_author) { create(:user) }
  given(:user_non_author) { create(:user) }
  given!(:question) { create(:question, user: user_author) }
  given!(:answer_first) { create(:answer, question: question, user: user_author) }
  given!(:answer_second) { create(:answer, question: question, user: user_author) }
  given!(:answer_third) { create(:answer, question: question, user: user_author) }

  describe "Authenticated user" do

    scenario "Author of question try to choose best answer" do
      sign_in user_author
      visit question_path(question)

      within "ul#answer-#{answer_first.id}" do
        click_on "Mark as the best"
      end
      answer_first.reload
      answer_second.reload
      answer_third.reload
      expect(answer_first.best_answer_id).to eq(answer_first.id)
      expect(answer_second.best_answer_id).to eq 0
      expect(answer_third.best_answer_id).to eq 0
    end

    scenario "Non-author of question try to choose best answer" do
      sign_in user_non_author
      visit question_path(question)
      expect(page).to_not have_selector "Mark as the best"
    end
  end

  describe "non-authenticated user" do
    scenario "try to choose best answer" do
      visit question_path(question)
      expect(page).to_not have_selector "Mark as the best"
    end
  end

end