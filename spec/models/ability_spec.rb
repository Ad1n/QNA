require 'rails_helper'

describe Ability do

  subject(:ability) { Ability.new(user) }

  describe "for quest" do
    let(:user) { nil }
    it { should be_able_to :read, [Question, Answer, Comment] }
    it { should_not be_able_to :manage, :all }
    %w[Question Answer Comment].each do |klass|
      it { should be_able_to :search, klass.classify.constantize }
    end
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question_other) { create(:question, user: other) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer_other) { create(:answer, question: question, user: other) }
    let(:other_question_answer) { create(:answer, question: question_other, user: other ) }
    let(:question_with_vote) { create(:question, user: other) }
    let(:vote_for) { create(:vote, votable: question_with_vote, user: user) }
    let(:unvote_for) { create(:unvote, votable: question_with_vote, user: user) }
    let(:my_attachment) { create(:attachment, attachable: question) }
    let(:other_attachment) { create(:attachment, attachable: question_other) }

    %w[Question Answer Comment ThinkingSphinx].each do |klass|
      it { should be_able_to :search, klass.classify.constantize }
    end
    it { should_not be_able_to :search, User }


    it { should be_able_to :me, User, user: user }
    it { should_not be_able_to :index, User }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to [:index, :create], Question }
    it { should be_able_to [:create, :show], Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to [:update, :destroy], question, user: user }
    it { should_not be_able_to [:update, :destroy], question_other, user: user }

    it { should be_able_to [:update, :destroy, :choose_best], answer, user: user }
    it { should_not be_able_to [:update, :destroy], answer_other, user: user }

    it { should_not be_able_to :choose_best, other_question_answer, user: user }

    it { should be_able_to :create, Subscribe }
    it { should be_able_to :destroy, Subscribe }

    context "vote" do

      before do
        question_with_vote
        question_other
        vote_for
        question
        answer_other
        answer
      end

      it { should_not be_able_to :vote, question_with_vote, user: user }
      it { should be_able_to :unvote, question_with_vote, user: user }

      it { should be_able_to [:vote, :unvote], question_other, user: user }
      it { should_not be_able_to :vote, question, user: user }

      it { should be_able_to :vote, answer_other, user: user }
      it { should_not be_able_to :vote, answer, user: user }

    end

    context "unvote" do

      before do
        question_with_vote
        unvote_for
        question
        answer_other
        answer
      end

      it { should_not be_able_to :unvote, question_with_vote, user: user }
      it { should be_able_to :vote, question_with_vote, user: user }

      it { should_not be_able_to :unvote, question, user: user }

      it { should be_able_to :unvote, answer_other, user: user }
      it { should_not be_able_to :unvote, answer, user: user }
    end

    context "attachment" do
      before do
        question
        question_other
        my_attachment
        other_attachment
      end

      it { should_not be_able_to :destroy, other_attachment, user: user }
      it { should be_able_to :destroy, my_attachment, user: user }

    end
  end
end
