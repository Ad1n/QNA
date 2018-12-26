require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do

      it 'saves the new answer in the database' do
        expect(@user).to eq(answer.user)
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js }.to change(question.answers, :count).by(1)
      end

      it "has status code 200" do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js
        expect(response.status).to eq(200)
      end

    end

    context 'with invalid attributes' do

      it 'does not save the new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id }, format: :js }.to_not change(Answer, :count)
      end

      it 'has status code 200' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id }, format: :js
        expect(response.status).to eq(200)
      end

    end
  end

  describe 'POST #choose_best_answer' do


    context "Author of question chooses best answer" do

      sign_in_user

      before do
        question
        answer
      end

      it "makes best answer" do
        post :choose_best, params: { id: answer.id }
        answer.reload
        expect(answer.best_answer_id).to_not be_nil
      end

      it "redirects to question answers" do
        post :choose_best, params: { id: answer.id }
        expect(response).to redirect_to question_path(question)
      end
    end

    context "Non-author of question chooses best answer" do

      sign_in_user

      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it "doesnt make best answer" do
        post :choose_best, params: { id: answer.id }
        answer.reload
        expect(answer.best_answer_id).to be_nil
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
        expect { delete :destroy, params: { id: answer.id, question_id: question.id }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'has status code 200' do
        delete :destroy, params: { id: answer.id, question_id: question.id }, format: :js
        expect(response.status).to eq(200)
      end
    end

    context "Non-author delete answer" do

      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it "doesnt delete answer" do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id }, format: :js }.to_not change(Answer, :count)
      end

      it "has status code 403" do
        delete :destroy, params: { id: answer.id, question_id: question.id }, format: :js
        expect(response.status).to eq(403)
      end
    end
  end

  describe "PATCH #update" do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, question: question, user: @user) }
    let!(:user2) { create(:user) }
    let!(:answer2) { create(:answer, question: question, user: user2) }

    context "Author updates answer" do

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context "Non-author updates answer" do

      it 'doesnt change answer attributes' do
        patch :update, params: { id: answer2, question_id: question, answer: { body: 'new body' } }, format: :js
        answer2.reload
        expect(answer2.body).to_not eq 'new body'
      end

      it 'has status code 403' do
        patch :update, params: { id: answer2, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response.status).to eq(403)
      end
    end
  end

end
