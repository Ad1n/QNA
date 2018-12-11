require "rails_helper"

class WithCommentables < ApplicationController; end

describe ApplicationController, type: :controller do
  with_model :WithCommentable do

    table do |t|
      t.string :title
      t.string :body
    end

    model do
      include Commentable
    end

  end

  # Controller for test concern Commented
  controller WithCommentables do
    include Commented

    def create
      @test = WithCommentable.create(title: "title", body: "body")
      @test.save
    end

    def question_params
      params.require(:test).permit(:title, :body)
    end
  end

  describe "POST #create_comment" do

    context "Authenticated user" do
      sign_in_user

      before {
        post :create, params: { title: "title", body: "body" }
      }

      specify "has status code 200" do
        routes.draw { post "create_comment" => "with_commentables#create_comment" }
        post :create_comment, params: { commentable: WithCommentable.first, id: WithCommentable.first.id, comment: { body: "test body" } }, format: :json
        expect(response.status).to eq 200
      end

      it 'saves the new comment in the database' do
        routes.draw { post "create_comment" => "with_commentables#create_comment" }
        expect { post :create_comment, params: { commentable: WithCommentable.first, id: WithCommentable.first.id, comment: { body: "test body" } }, format: :json }.to change(WithCommentable.first.comments, :count).by(+1)
      end

    end

    context "Non-authenticated user" do

      before {
        post :create, params: { title: "title", body: "body" }
      }

      it 'doesnt save the new comment in the database' do
        routes.draw { post "create_comment" => "with_commentables#create_comment" }
        expect { post :create_comment, params: { commentable: WithCommentable.first, id: WithCommentable.first.id, comment: { body: "test body" } }, format: :json }.to_not change(WithCommentable.first.comments, :count)
      end
    end
  end

end