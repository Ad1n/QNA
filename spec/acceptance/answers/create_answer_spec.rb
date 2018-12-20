require_relative "../acceptance_helper"

feature "Create new answer for current question", %(
In order to help with finding answers for question
as a user
i want to be able to create answer.
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:second_user) { create(:user) }
  given(:another_question) { create(:question, user: user) }

  before {
    user.confirm
    second_user.confirm
  }

  context "Multiple sessions" do

    before { another_question }

    scenario "Answer appears on another question's page", js: true do
      Capybara.using_session('user_answer') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest_answer') do
        visit question_path(question)
      end

      Capybara.using_session('user_answer') do
        fill_in :answer_body, with: "Test answer"
        click_on "Do not add file"
        click_on "Answer the question"
        within '.answers' do
          expect(page).to have_content("Test answer")
        end
      end

      Capybara.using_session('guest_answer') do
        within '.answers' do
          expect(page).to have_content("Test answer")
        end
      end
    end

    scenario "Answer appears on another question's page only for current question", js: true do

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
        fill_in :answer_body, with: "Test answer"
        click_on "Do not add file"
        click_on "Answer the question"

        within '.answers' do
          expect(page).to have_content("Test answer")
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content("Test answer")
        end
      end

      Capybara.using_session('second_user') do
        expect(page).to_not have_content "Test answer"
      end
    end
  end

  scenario "User be able to see errors in current page", js: true do
    sign_in(user)
    visit question_path(question)
    click_on "Answer the question"

    expect(page).to have_content("Body can't be blank")
  end

  scenario "Authenticated user try to create answer for current question", js: true do
    sign_in(user)
    visit question_path(question)
    fill_in :answer_body, with: "Test answer"
    click_on "Do not add file"
    click_on "Answer the question"

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content("Test answer")
    end
  end

  scenario "Non-authenticated user try to create answer for question.", js: true do
    visit question_path(question)
    expect(page).to_not have_selector "Answer the question"
  end



end