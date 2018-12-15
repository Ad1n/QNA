require_relative "../acceptance_helper"

feature 'Delete answer', %(
  In order to delete my answer(s) from community
  as an authenticated user
  i want to be able to delete answers.
) do

  given(:user_author) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user_author) }
  given!(:answer) { create(:answer, question: question, user: user_author) }

  scenario "Author of answer try to delete his answer.", js: true do
    sign_in(user_author)
    visit question_path(question)
    expect(page).to have_content(answer.body)
    click_on "Delete"
    expect(page).to_not have_content(answer.body)
  end

  scenario "Not an author of answer try to delete answer.", js: true do
    sign_in(user_not_author)
    visit question_path(question)
    expect(page).to have_content(answer.body)
    expect(page).to_not have_link "Delete"
  end

  scenario "Non-authenticated user try to delete answer." do
    visit question_path(question)
    expect(page).to_not have_link "Delete"
  end

end