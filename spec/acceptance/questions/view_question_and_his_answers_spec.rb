require "rails_helper"

feature "View question and his answers", %(
In order to find answer for my question
as a user
i want to be able to view question and his answers.
) do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question_id: question.id) }

  scenario "User view question and his answers" do
    visit question_path(question, answer)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(answer.body)
  end

end