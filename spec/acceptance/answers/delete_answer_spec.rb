require 'rails_helper'

feature 'Delete answer', %(
  In order to delete my answer(s) from community
  as an authenticated user
  i want to be able to delete answers.
) do

  given(:user_author) { create(:user) }
  given(:user_not_author) { create(:user) }
  given(:question) { create(:question, user_id: user_author.id) }
  given(:answer) { create(:answer, question_id: question.id, user_id: user_author.id) }

  scenario "Author of answer try to delete his answer." do
    sign_in(user_author)
    delete_answer(question, answer)

    expect(page).to_not have_content(answer.body)
  end

  scenario "Not an author of answer try to delete answer." do
    sign_in(user_not_author)
    delete_answer(question, answer)

    expect(page).to have_content("You are not the author of this answer.")
  end

  scenario "Non-authenticated user try to delete answer." do
    visit question_path(question, answer)
    expect(page).to_not have_selector(:link, "Delete")
  end

end