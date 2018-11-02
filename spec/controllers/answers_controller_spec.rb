require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    sign_in_user

    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do

      it 'save the new answer in the database' do
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
        expect(response).to render_template :new
      end

    end
  end
end
