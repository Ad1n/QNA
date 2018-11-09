require "rails_helper"

RSpec.describe User, type: :model do

  describe "Validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe "Associations" do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  it "User#author_of?" do
    current_user = described_class.new(email: "test@test.com", password: "12345678", password_confirmation: "12345678")
    question = Question.new(title: "test title", body: "test body", user: current_user)
    expect(current_user.id).to eq(question.user.id)
  end
end