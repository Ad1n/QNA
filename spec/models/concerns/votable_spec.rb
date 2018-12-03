require "rails_helper"

describe "votable" do

  with_model :WithVotable do

    model do
      include Votable
    end

  end

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:vote) { create(:vote, votable: question, user: user) }

  it "has the module" do
    expect(WithVotable.include?(Votable)).to eq true
  end

  it "#rating" do
    expect(WithVotable.new.rating).to eq 0
    expect(question.rating).to eq 1
  end

  it "#object_rating" do
    expect(question.object_rating(user)).to eq 1
    expect(question.object_rating).to eq 1
  end
end
