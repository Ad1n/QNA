require "rails_helper"

RSpec.describe BestAnswer do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:best_answer) { create(:answer, question: question, user: user) }
  let!(:another_answer) { create(:answer, question: question, user: user) }

  it "should set best answer id for best answer" do
    choice = BestAnswer.new(best_answer)
    choice.make_choice
    expect { best_answer.reload }.to change(best_answer, :best_answer_id).from(nil).to(1)
    expect { another_answer.reload }.to change(another_answer, :best_answer_id).from(nil).to(0)
  end
end