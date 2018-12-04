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
    expect(WithVotable.new.object_rating(user)).to eq 0
    expect(question.object_rating(user)).to eq 1
  end

  it "#can_vote?" do
    expect(question.can_vote?(user)).to eq false
  end

  it "#can_unvote?" do
    expect(question.can_unvote?(user)).to eq true
  end

  describe "Making voting" do

    let!(:question_without_vote) { create(:question, user: user) }

    it "#make_vote(user)" do
      expect(question_without_vote.make_vote(user)).to be_an_instance_of(Vote)
    end

    it "#make_uvote(user)" do
      expect(question_without_vote.make_unvote(user)).to be_an_instance_of(Vote)
    end

  end
end
