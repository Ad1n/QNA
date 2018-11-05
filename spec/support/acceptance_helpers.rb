module AcceptanceHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  def view_question_list(questions)
    visit questions_path(questions)

    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end

  def create_answer(question)
    visit question_path(question)
    fill_in :body, with: "Test answer"
    click_on "Answer the question"
  end

end
