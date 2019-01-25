require_relative "../acceptance_helper"

feature "Delete file from question", %q(
  In order to delete useless file in my question
  As author of question
  I'd like to be able to delete file
) do

  given(:user) { create(:user) }
  given(:user_non_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  before {
    user.confirm
    user_non_author.confirm
  }

  describe "Non-authenticated user" do
    scenario "doesnt see link for file delete", js: true do
      visit question_path(question)
      expect(page).to_not have_link "Delete file"
    end
  end

  describe "Author of question" do

    before { sign_in user }

    scenario "deletes his attachment file", js: true do
      visit question_path(question)

      within "div#attachment-#{attachment.id}" do
        accept_alert do
          click_on "Delete file"
        end
      end

      expect(page).to_not have_link(attachment.file)
    end
  end

  describe "Non-author of question" do
    before { sign_in user_non_author }

    scenario "cannot delete file", js: true do
      visit question_path(question)

      within "div#attachment-#{attachment.id}" do
        expect(page).to_not have_link "Delete file"
      end
    end
  end

end
