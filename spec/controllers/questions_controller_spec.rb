require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }


  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do

    before do
      get :show, params: { id: question }
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer of current question to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question, user: @user) }

    context 'with valid attributes' do
      it 'save the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirect to the show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders show view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    # This part can not ref due to "Deep error"
    context "non-authenticated user updates question" do
      before do
        patch :update, params: { id: question, question: { title: "New title", body: 'New body' } }, format: :js
      end

      it 'doesnt change question attributes' do
        question.reload
        expect(question.title).to_not eq 'New title'
        expect(question.body).to_not eq 'New body'
      end

      it 'receives response status 401' do
        expect(response.status).to eq(401)
      end
    end

    context "as authenticated author of question with valid attributes" do
      sign_in_user
      let!(:question) { create(:question, user: @user) }

      it 'assign the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      def request
        patch :update, params: { id: question, question: { title: "New title", body: "New body" } }, format: :js
      end

      def param_for
        { status: 200, equals: :to }
      end

      it_behaves_like "updated question"
    end

    context "as authenticated author of question with invalid attributes" do
      sign_in_user
      let!(:question) { create(:question, user: @user) }

      def request
        patch :update, params: { id: question, question: { title: 'New title', body: nil } }, format: :js
      end

      def param_for
        { status: 200, equals: :to_not }
      end

      it_behaves_like "updated question"
    end

    context "as authenticated non-author with valid attributes" do
      sign_in_user

      def request
        patch :update, params: { id: question, question: { title: "New title", body: "New body" } }, format: :js
      end

      def param_for
        { status: 403, equals: :to_not }
      end

      it_behaves_like "updated question"
    end

    context "as authenticated non-author with invalid attributes" do
      sign_in_user

      def request
        patch :update, params: { id: question, question: { title: 'New title', body: nil } }, format: :js
      end

      def param_for
        { status: 403, equals: :to_not }
      end

      it_behaves_like "updated question"
    end
  end

  describe 'DELETE #destroy' do

    sign_in_user

    context "Author delete question" do

      let!(:question) { create(:question, user: @user) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(@user.questions, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context "Non-author delete question" do

      before { question }

      it "doesnt delete question" do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end

    end

  end
end
