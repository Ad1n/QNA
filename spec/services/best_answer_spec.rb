require "rails_helper"

RSpec.describe BestAnswer do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:best_answer) { create(:answer, question: question, user: user) }
  let!(:another_answer) { create(:answer, question: question, user: user) }


  it "should set best answer id for best answer" do
    choice = BestAnswer.new(question, best_answer)

    expect { choice.make_choice }.to change(best_answer, :best_answer_id).from(nil).to(best_answer.id)
  end


end