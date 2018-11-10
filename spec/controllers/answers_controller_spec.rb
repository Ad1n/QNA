require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do

      it 'save the new answer in the database' do
        expect(@user).to eq(answer.user)
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(question.answers, :count).by(1)
      end

      it "redirect to the current question's answers" do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to question_path(question)
      end

    end

    context 'with invalid attributes' do

      it 'does not save the new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id } }.to_not change(Answer, :count)
      end

      it 're-renders show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id }
        expect(response).to render_template "questions/show"
      end

    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context "Author delete answer" do

      before do
        question
        answer
      end

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to question_path(question)
      end
    end

    context "Non-author delete answer" do

      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it "Non-delete answer" do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to_not change(Answer, :count)
      end

      it "Redirects to question show view" do
        delete :destroy, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

end
