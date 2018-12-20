require_relative "../acceptance_helper"

feature "Create comment for answer", %(
In order to discuss answer
as a user
i want to be able to create comment for question.
) do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  before {
    user.confirm
    second_user.confirm
  }

  context "Non-authenticated user" do
    scenario "try to create comment for answer" do
      visit question_path(question)

      expect(page).to_not have_content "Send"
    end
  end

  context "Authenticated user" do

    before { sign_in(user) }

    scenario "create comment for answer", js: true do
      visit question_path(question)
      within "#answer-#{answer.id}" do
        fill_in :comment_body, with: "Test comment"
        click_on "Send"

        expect(page).to have_content "Test comment"
      end
    end
  end

  context "Multiple sessions" do

    before { another_question }

    scenario "Answer's comment appears on another answer's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          fill_in :comment_body, with: "Test comment"
          click_on "Send"

          expect(page).to have_content "Test comment"
        end
      end

      Capybara.using_session('guest') do
        within "#answer-#{answer.id}" do
          expect(page).to have_content "Test comment"
        end
      end

    end

    scenario "Answer's comment appears on another answer's page only for current question", js: true do

      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('second_user') do
        sign_in second_user
        visit question_path(another_question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          fill_in :comment_body, with: "Test comment"
          click_on "Send"

          expect(page).to have_content "Test comment"
        end
      end

      Capybara.using_session('guest') do
        within "#answer-#{answer.id}" do
          expect(page).to have_content "Test comment"
        end
      end

      Capybara.using_session('second_user') do
        expect(page).to_not have_content "Test comment"
      end
    end
  end
end

