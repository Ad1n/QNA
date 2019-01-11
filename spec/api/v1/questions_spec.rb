require 'rails_helper'

RSpec.describe "Questions API" do
  describe "GET /index" do
    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/questions", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if  invalid access_token" do
        get "/api/v1/questions", params: { format: :json, access_token: "123" }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: user)}

      before {
        get "/api/v1/questions", params: { format: :json, access_token: access_token.token }
      }

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

    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if  invalid access_token" do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: "123" }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do

      before {
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      }

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

    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        post "/api/v1/questions", params: { format: :json, question: { title: "Test title", body: "test body" } }
        expect(response.status).to eq 401
      end

      it "returns 401 status if  invalid access_token" do
        post "/api/v1/questions", params: { format: :json, question: { title: "Test title", body: "test body" }, access_token: "123" }
        expect(response.status).to eq 401
      end
    end

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