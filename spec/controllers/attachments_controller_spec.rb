require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  sign_in_user

  let(:user) { create(:user) }
  let(:author_question) { create(:question, user: @user) }
  let(:non_author_question) { create(:question, user: user) }
  let(:author_attachment) { create(:attachment, attachable: author_question) }
  let(:non_author_attachment) { create(:attachment, attachable: non_author_question) }

  describe 'DELETE #destroy' do
    context "Author deletes attachment file" do

      before do
        author_question
        author_attachment
      end

      it "deletes attachment file" do
        expect { delete :destroy, params: { id: author_attachment }, format: :js }.to change(author_question.attachments, :count).by(-1)
      end

      it "responds status code 200" do
        delete :destroy, params: { id: author_attachment }, format: :js
        expect(response.status).to eq(200)
      end
    end

    context "Non-author deletes attachment file" do

      before do
        non_author_question
        non_author_attachment
      end

      it "doesnt delete attachment file" do
        expect { delete :destroy, params: { id: non_author_attachment }, format: :js }.to_not change(non_author_question.attachments, :count)
      end

      it "responds status code 302" do
        delete :destroy, params: { id: non_author_attachment }, format: :js
        expect(response.status).to eq(302)
      end
    end
  end


end
