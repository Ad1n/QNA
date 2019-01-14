shared_examples_for "voted vote/unvote" do
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

    it 'saves the new vote in the database' do
      route
      expect { request }.to change(WithVotable.first.votes, :count).by(+1)
    end

  end

  context "Non-authenticated user" do

    before {
      post :create, params: { title: "title", body: "body" }
    }

    it 'saves the new vote in the database' do
      route
      expect { request }.to_not change(WithVotable.first.votes, :count)
    end
  end
end
