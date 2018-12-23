require_relative "../acceptance_helper"

feature "Create comment for question", %(
In order to discuss question
as a user
i want to be able to create comment for question.
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  before {
    user.confirm
  }

  context "Non-authenticated user" do
    scenario "try to create comment for question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content "Send"
    end
  end

  context "Authenticated user" do

    before { sign_in(user) }

    scenario "create comment for question", js: true do
      visit question_path(question)
      fill_in :comment_body, with: "Test comment"
      click_on "Send"

      expect(page).to have_content "Test comment"
    end
  end

  context "Multiple sessions" do
    scenario "Question's comment appears on another question's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in :comment_body, with: "Test comment"
        click_on "Send"

        expect(page).to have_content "Test comment"
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "Test comment"
      end

    end
  end
end

