require "rails_helper"

RSpec.describe User, type: :model do

  describe "Associations" do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe "Validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe "#author_of?" do

    before do
      @current_user = create(:user)
    end

    it "return true" do
      question = create(:question, user: @current_user)
      expect(@current_user.author_of?(question)).to eq true
    end

    it "return false" do
      question_author = create(:user)
      question = create(:question, user: question_author)
      expect(@current_user.author_of?(question)).to eq false
    end
  end

end