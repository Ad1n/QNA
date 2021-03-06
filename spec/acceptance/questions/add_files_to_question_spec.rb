require_relative "../acceptance_helper"

feature "Add files to question", %q(
  In order to illustrate my question
  As author of question
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }

  background do
    user.confirm
    sign_in(user)
    visit new_question_path
  end

  scenario "User adds file when asks question" do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'

    attach_file "File", "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb'
  end

  scenario "User adds several files when asks question", js: true do

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'

    click_on "Add file"

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end