require "rails_helper"

feature "Create new answer for current question", %(
In order to create answer for current question
as a user
i want to be able to create answer.
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question_id: question.id) }

  scenario "Authenticated user create answer for current quesiton" do
    sign_in(user)
    visit question_path(question)
    fill_in :body, with: answer.body
    click_on "Answer the question"

    expect(page).to have_content(answer.body)
  end

end