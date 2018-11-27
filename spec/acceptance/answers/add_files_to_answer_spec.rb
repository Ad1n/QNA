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

  scenario "User adds file to answer", js: true do
    fill_in 'answer_body', with: 'My answer'
    attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Answer the question'

    within ".answers" do
      expect(page).to have_link 'spec_helper.rb'

    end
  end

  scenario "User adds several files to answer", js: true do

    fill_in 'answer_body', with: 'My text'

    click_on "Add file"

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Answer the question'
    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end