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

    skip_authorization_check only: :create

    def create
      @test = WithVotable.create(title: "title", body: "body")
      @test.save
    end

    private

    def question_params
      params.require(:test).permit(:title, :body)
    end
  end

  describe "POST #vote" do

    def route
      routes.draw { post "vote" => "with_votables#vote" }
    end

    def request
      post :vote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json
    end

    it_behaves_like "voted vote/unvote"

  end

  describe "POST #unvote" do

    def route
      routes.draw { post "unvote" => "with_votables#unvote" }
    end

    def request
      post :unvote, params: { votable: WithVotable.first, id: WithVotable.first.id }, format: :json
    end

    it_behaves_like "voted vote/unvote"
  end
end