require_relative "../acceptance_helper"

feature "Delete file from answer", %q(
  In order to delete useless file in my answer
  As author of answer
  I'd like to be able to delete file
) do

  given(:user) { create(:user) }
  given(:user_non_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  describe "Non-authenticated user" do
    scenario "doesnt see link for file delete", js: true do
      visit question_path(question)
      expect(page).to_not have_link "Delete file"
    end
  end

  describe "Author of answer" do

    before { sign_in user }

    scenario "deletes his attachment file", js: true do
      visit question_path(question)

      within "div#attachment-#{attachment.id}" do
        click_on "Delete file"
      end

      expect(page).to_not have_link(attachment.file)
    end
  end

  describe "Non-author of answer" do
    before { sign_in user_non_author }

    scenario "cannot delete file", js: true do
      visit question_path(question)

      within "div#attachment-#{attachment.id}" do
        expect(page).to_not have_link "Delete file"
      end
    end
  end
end