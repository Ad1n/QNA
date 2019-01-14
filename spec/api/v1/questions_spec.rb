require 'rails_helper'

RSpec.describe "Questions API" do
  describe "GET /index" do

    def do_request(options = {})
      get "/api/v1/questions", params: { format: :json }.merge(options)
    end

    it_behaves_like "API is unauthorized"

    context "authorized" do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: user)}

      before do
        get "/api/v1/questions", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status code" do
        expect(response).to be_successful
      end

      it "returns list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it "question object contain short title" do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end
    end
  end

  describe "GET /show" do
    let!(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user)}
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:comment) { create(:comment, user: user, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end

    it_behaves_like "API is unauthorized"

    context "authorized" do

      before do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status code" do
        expect(response).to be_successful
      end

      it "returns requested question" do
        expect(response.body).to have_json_size(9).at_path("question")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end


      context "answers" do

        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("question/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context "attachments" do

        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it "contains attachment" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file")
        end
      end

      context "comments" do

        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at commentable_type commentable_id ).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe "POST /create" do
    let!(:user) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

    def do_request(options = {})
      post "/api/v1/questions", params: { format: :json, question: { title: "Test title", body: "test body" } }.merge(options)
    end

    it_behaves_like "API is unauthorized"

    context "authorized" do

      before {
        post "/api/v1/questions", params: { format: :json, question: { title: "Test title", body: "test body" }, access_token: access_token.token }
      }

      it "returns 200 status code" do
        expect(response).to be_successful
      end

      it "creates new question" do
        expect(response.body).to have_json_size(9).at_path("question")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(Question.last.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end
  end


end