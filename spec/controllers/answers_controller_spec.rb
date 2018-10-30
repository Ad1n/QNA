require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id, id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'save the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id, id: question } }.to change(Answer, :count).by(1)
      end

      it "redirect to the current question's answers" do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id, id: question }
        expect(response).to redirect_to question_path(question)
      end

    end

    context 'with invalid attributes' do

      it 'does not save the new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id, id: question } }.to_not change(Answer, :count)
      end

      it 're-renders show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id, id: question }
        expect(response).to render_template :new, params: { question_id: question.id, id: question }
      end

    end
  end
end
