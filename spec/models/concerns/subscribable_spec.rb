require 'rails_helper'

describe "subscribable" do

  with_model :WithSubscribable do

    model do
      include Subscribable
    end

  end

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:subscribe) { create(:subscribe, subscribable: question, user: user) }

  it "has the module" do
    expect(WithSubscribable.include?(Subscribable)).to eq true
  end

  describe "question" do
    it "has many subscribes" do
      expect(question.subscribes).to eq [subscribe]
    end
  end
end