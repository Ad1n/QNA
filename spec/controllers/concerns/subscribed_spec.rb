require "rails_helper"

class WithSubscribable < ApplicationController; end

describe ApplicationController, type: :controller do
  with_model :WithSubscribable do

    table do |t|
      t.string :title
      t.string :body
    end

    model do
      include Subscribable

      def subscribe_by(user)
        subscribes.where(user: user)
      end
    end

  end

  controller WithSubscribable do
    include Subscribed

    skip_authorization_check only: [:create, :subscribe, :unsubscribe]

    def create
      @test = WithSubscribable.create!(title: "title", body: "body")
    end

    private

    def question_params
      params.require(:test).permit(:title, :body)
    end
  end

  describe "POST #subscribe" do
    let(:user) { create(:user) }

    def route
      routes.draw { post "subscribe" => "with_subscribable#subscribe" }
    end

    def request
      post :subscribe, params: { subscribable: WithSubscribable.first, id: WithSubscribable.first.id, user: user }, format: :json
    end

    context "Authenticated user" do
      sign_in_user

      before {
        post :create, params: { title: "title", body: "body" }
      }

      specify "has status code 200" do
        route
        request
        expect(response.status).to eq 200
      end

      it 'saves the new subscribe in the database' do
        route
        expect { request }.to change(WithSubscribable.first.subscribes, :count).by(+1)
      end

    end

    context "Non-authenticated user" do

      before {
        post :create, params: { title: "title", body: "body" }
      }

      it 'doesnt save the new subscribe in the database' do
        route
        expect { request }.to_not change(WithSubscribable.first.subscribes, :count)
      end
    end

  end

  describe "POST #unsubscribe" do
    let(:user) { create(:user) }

    def route
      routes.draw { delete "unsubscribe" => "with_subscribable#unsubscribe" }
    end

    def request
      delete :unsubscribe, params: { id: WithSubscribable.first.id }, format: :json
    end


    context "Authenticated user" do
      sign_in_user

      before {
        post :create, params: { title: "title", body: "body" }
        routes.draw { post "subscribe" => "with_subscribable#subscribe" }
        post :subscribe, params: { subscribable: WithSubscribable.first, id: WithSubscribable.first.id, user: user }, format: :json
      }

      specify "has status code 200" do
        route
        request
        expect(response.status).to eq 200
      end

      it 'delete subscribe from the database' do
        route
        expect { request }.to change(WithSubscribable.first.subscribes, :count).by(-1)
      end

    end

    context "Non-authenticated user" do

      before {
        post :create, params: { title: "title", body: "body" }
        routes.draw { post "subscribe" => "with_subscribable#subscribe" }
        post :subscribe, params: { subscribable: WithSubscribable.first, id: WithSubscribable.first.id, user: user }, format: :json
      }

      it 'doesnt save the new subscribe in the database' do
        route
        expect { request }.to_not change(WithSubscribable.first.subscribes, :count)
      end
    end
  end
end
