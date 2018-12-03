require "rails_helper"

class WithVotables < ApplicationController; end

describe ApplicationController, type: :controller do
  with_model :WithVotable do

    table do |t|
      t.string :title
      t.string :body
    end

    model do
      include Votable
    end

  end

  # Controller for test concern Voted
  controller WithVotables do
    include Voted

    def create
      @test = WithVotable.create(title: "title", body: "body")
      @test.save
    end

    def question_params
      params.require(:test).permit(:title, :body)
    end
  end

  describe "POST #vote" do

    context "Authenticated user" do
      sign_in_user

      before {
        post :create, params: { title: "title", body: "body" }
      }

      specify "has status code 200" do
        routes.draw { post "vote" => "with_votables#vote" }
        post :vote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json
        expect(response.status).to eq 200
      end

      it 'saves the new vote in the database' do
        routes.draw { post "vote" => "with_votables#vote" }
        expect { post :vote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json }.to change(WithVotable.first.votes, :count).by(+1)
      end

    end

    context "Non-authenticated user" do

      before {
        post :create, params: { title: "title", body: "body" }
      }

      it 'saves the new vote in the database' do
        routes.draw { post "vote" => "with_votables#vote" }
        expect { post :vote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json }.to_not change(WithVotable.first.votes, :count)
      end
    end
  end

  describe "POST #unvote" do

    context "Authenticated user" do
      sign_in_user

      before {
        post :create, params: { title: "title", body: "body" }
      }

      specify "has status code 200" do
        routes.draw { post "unvote" => "with_votables#unvote" }
        post :unvote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json
        expect(response.status).to eq 200
      end

      it 'saves the new vote in the database' do
        routes.draw { post "unvote" => "with_votables#unvote" }
        expect { post :unvote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json }.to change(WithVotable.first.votes, :count).by(+1)
      end

    end

    context "Non-authenticated user" do

      before {
        post :create, params: { title: "title", body: "body" }
      }

      it 'saves the new vote in the database' do
        routes.draw { post "unvote" => "with_votables#unvote" }
        expect { post :unvote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json }.to_not change(WithVotable.first.votes, :count)
      end
    end
  end
end