require "rails_helper"

feature "Create new answer for current question", %(
In order to help with finding answers for question
as a user
i want to be able to create answer.
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "User be able to see errors in current page" do
    sign_in(user)
    visit question_path(question)
    click_on "Answer the question"

    expect(page).to have_content("Body can't be blank")
  end

  scenario "Authenticated user try to create answer for current quesiton" do
    sign_in(user)
    visit question_path(question)
    fill_in :answer_body, with: "Test answer"
    click_on "Answer the question"

    expect(page).to have_content("Test answer")
  end

  scenario "Non-authenticated user try to create answer for question." do
    visit question_path(question)
    fill_in :answer_body, with: "Test answer"
    click_on "Answer the question"
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

end