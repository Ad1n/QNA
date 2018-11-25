require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe "#make_choice" do

    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:best_answer) { create(:answer, question: question, user: user) }
    let!(:another_answer) { create(:answer, question: question, user: user) }

    it "should set best answer id for best answer" do
      expect { best_answer.make_choice }.to change(best_answer, :best_answer_id).from(nil).to(1)
      another_answer.reload
      expect(another_answer.best_answer_id).to eq 0
    end
  end

end
