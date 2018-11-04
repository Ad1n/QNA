require "rails_helper"

feature "View list of questions", %(
In order to view list of questions
as an user
i want to be able to view list of questions.
) do

  given(:questions) { create_list(:question, 3) }
  given(:user) { create(:user) }

  scenario "Non-authenticated user view list of all questions" do
    view_question_list(questions)
  end

  scenario "Authenticated user view list of all questions" do
    sign_in(user)
    view_question_list(questions)
  end

end