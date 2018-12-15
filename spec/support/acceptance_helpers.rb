module AcceptanceHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  def view_question_list(questions)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end
