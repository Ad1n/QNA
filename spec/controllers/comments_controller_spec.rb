require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:question) { create(:question, user: @user) }

  describe "POST #create" do

    sign_in_user

    context "with valid attributes" do

      before {
        question
      }

      it "has status code 200" do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :json
        expect(response.status).to eq 200
      end

      it 'saves the new comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question  }, format: :json }.to change(Comment, :count).by(+1)
      end

    end

    context "with invalid attributes" do

      before {
        question
      }

      it 'doesnt save the new comment in the database' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment), question_id: question }, format: :json }.to_not change(Comment, :count)
      end
    end
  end

end
