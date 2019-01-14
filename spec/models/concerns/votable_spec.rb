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

  describe "#can_vote?(user, action_name)" do

    let!(:question_without_vote) { create(:question, user: user) }
    let!(:question_with_unvote) { create(:question, user: user) }
    let!(:unvote) { create(:unvote, votable: question_with_unvote, user: user) }

    it "returns true if conditions have been met for vote action" do
      expect(question.can_vote?(user, "vote")).to eq false
    end

    it "returns false if conditions have not been met for vote action" do
      expect(question_without_vote.can_vote?(user, "vote")).to eq true
    end

    it "returns true if conditions have been met for unvote action" do
      expect(question_with_unvote.can_vote?(user, "unvote")).to eq false
    end

    it "returns false if conditions have not been met for unvote action" do
      expect(question_without_vote.can_vote?(user, "unvote")).to eq true
    end
  end

  describe "#make_vote(user, action_name)" do

    let!(:question_without_vote) { create(:question, user: user) }

    after do
      expect(question_without_vote.votes.first.votable_type).to eq "Question"
      expect(question_without_vote.votes.first.votable_id).to eq question_without_vote.id
    end

    it "create new vote in database for vote action" do
      expect{ question_without_vote.make_vote(user, "vote") }.to change{ Vote.count }.by(1)
      expect(question_without_vote.object_rating(user)).to eq 1
    end

    it "create new vote in database for unvote action" do
      expect{ question_without_vote.make_vote(user, "unvote") }.to change{ Vote.count }.by(1)
      expect(question_without_vote.object_rating(user)).to eq -1
    end

  end
end
