require 'rails_helper'

RSpec.describe "Answers API" do
  describe "GET /show" do

    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user)}
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:comment) { create(:comment, user: user, commentable: answer) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if  invalid access_token" do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: "123" }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do

      before {
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }
      }

      it "returns 200 status code" do
        expect(response).to be_successful
      end

      it "returns requested answer" do
        expect(response.body).to have_json_size(8).at_path("answer")
      end

      %w(id body question_id created_at updated_at best_answer_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context "attachments" do

        it "included in answer object" do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it "contains attachment" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/file")
        end
      end

      context "comments" do

        it "included in answer object" do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at commentable_type commentable_id ).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe "POST /create" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: { body: "test body" }, question_id: question.id }
        expect(response.status).to eq 401
      end

      it "returns 401 status if  invalid access_token" do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                   answer: { body: "test body" },
                                                                   question_id: question.id,
                                                                   access_token: "123" }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do

      before {
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                   answer: { body: "test body" },
                                                                   question_id: question.id,
                                                                   access_token: access_token.token }
      }

      it "returns 200 status code" do
        expect(response).to be_successful
      end

      it "creates new answer" do
        expect(response.body).to have_json_size(8).at_path("answer")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(Answer.last.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end

end
