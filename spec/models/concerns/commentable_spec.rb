require "rails_helper"

describe "commentable" do

  with_model :WithCommentable do

    model do
      include Commentable
    end

  end

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  it "has the module" do
    expect(WithCommentable.include?(Commentable)).to eq true
  end

  describe "question" do
    it "has many comments" do
      expect(question.comments).to eq [comment]
    end
  end

end
