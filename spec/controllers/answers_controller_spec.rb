require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  before { @user = create(:user) }
  let(:question) { create(:question, user_id: @user.id) }

  describe 'GET #new' do
    sign_in_user

    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template "answers/new"
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do

      it 'save the new answer in the database' do
        expect { post :create, params: attributes_for(:answer).merge(question_id: question.id) }.to change(question.answers, :count).by(1)
      end

      it "redirect to the current question's answers" do
        post :create, params: attributes_for(:answer).merge(question_id: question.id)
        expect(response).to redirect_to question_path(question)
      end

    end

    context 'with invalid attributes' do

      it 'does not save the new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id } }.to_not change(Answer, :count)
      end

      it 're-renders show view' do
        post :create, params: attributes_for(:invalid_answer).merge(question_id: question.id, user_id: @user.id)
        expect(response).to redirect_to question_path(question)
      end

    end
  end
end
