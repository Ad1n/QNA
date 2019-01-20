require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  let(:question) { create(:question, user: @user) }

  describe "POST #create" do

    context "authenticated user" do
      sign_in_user

      before do
        question
        question.subscribes = []
      end

      it "has status code 200" do
        post :create, params: { question_id: question.id }, format: :json
        expect(response.status).to eq 200
      end

      it 'create subscribe in the database' do
        expect { post :create, params: { question_id: question.id }, format: :json }.to change(Subscribe, :count).by(+1)
      end
    end

    context "non-authenticated user" do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }

      before {
        question.subscribes = []
      }

      it 'doesnt save the new subscribe in the database' do
        expect { post :create, params: { question_id: question.id }, format: :json }.to_not change(Subscribe, :count)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:subscribe) { question.subscribes.first }

    context "authenticated user" do

      sign_in_user

      before do
        question
        subscribe
      end

      it "has status code 200" do
        delete :destroy, params: { question_id: question.id, id: subscribe.id }, format: :json
        expect(response.status).to eq 200
      end

      it 'create subscribe in the database' do
        expect { delete :destroy, params: { question_id: question.id, id: subscribe.id }, format: :json }.to change(Subscribe, :count).by(-1)
      end
    end

    context "non-authenticated user" do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }

      it 'doesnt save the new subscribe in the database' do
        expect { delete :destroy, params: { question_id: question.id, id: subscribe.id }, format: :json }.to_not change(Subscribe, :count)
      end
    end
  end
end
