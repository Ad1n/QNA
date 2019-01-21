require 'rails_helper'

describe "subscribable" do

  with_model :WithSubscribable do

    model do
      include Subscribable
    end

  end

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  it "has the module" do
    expect(WithSubscribable.include?(Subscribable)).to eq true
  end

  describe "question" do
    it "Created question has a auto-subscribe" do
      expect(question.subscribes.first).to be_a(Subscribe)
    end
  end
end