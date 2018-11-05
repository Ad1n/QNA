require "rails_helper"

feature "Create new answer for current question", %(
In order to help with finding answers for question
as a user
i want to be able to create answer.
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  scenario "Authenticated user try to create answer for current quesiton" do
    sign_in(user)
    create_answer(question)

    expect(page).to have_content("Test answer")
  end

  scenario "Non-authenticated user try to create answer for question." do
    create_answer(question)
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

end