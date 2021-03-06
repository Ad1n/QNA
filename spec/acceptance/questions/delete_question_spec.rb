require_relative "../acceptance_helper"

feature 'Delete question', %(
  In order to delete my own question from community
  as an authenticated author of this question
  i want to be able to delete my questions.
) do

  given(:user_author) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user_id: user_author.id) }

  before {
    user_author.confirm
    user_not_author.confirm
  }

  scenario "Author of question try to delete his question" do
    sign_in(user_author)
    visit questions_path
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    click_on "Delete"

    expect(page).to_not have_content(question.title)
    expect(page).to_not have_content(question.body)
  end

  scenario "Not an author of question try to delete question" do
    sign_in(user_not_author)
    visit questions_path
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to_not have_link "Delete"
  end

  scenario "Non-authenticated user try to delete question" do
    visit questions_path
    expect(page).to_not have_link "Delete"
  end
end