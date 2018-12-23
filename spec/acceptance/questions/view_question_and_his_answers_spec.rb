require_relative "../acceptance_helper"

feature "View question and his answers", %(
In order to find answer for my question
as a user
i want to be able to view question and his answers.
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  before {
    user.confirm
  }

  scenario "User try to view question and his answers" do
    visit question_path(question)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

end