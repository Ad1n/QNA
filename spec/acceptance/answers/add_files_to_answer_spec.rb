require_relative "../acceptance_helper"

feature "Add files to answer", %(
 In order to illustrate my answer
  As author of answer
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "User adds file when asks question" do
    fill_in 'answer_body', with: 'My answer'
    attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    within ".answers" do
      expect(page).to have_link 'spec_helper.rb'

    end
  end
end