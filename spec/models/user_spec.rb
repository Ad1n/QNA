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

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'returns true for author' do
      expect(user).to be_author_of(question)
    end

    it 'returns false for non author' do
      expect(another_user).to_not be_author_of(question)
    end
  end

end