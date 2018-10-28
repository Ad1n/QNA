require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should have_many(:answers) }

  it 'destroys dependent answers' do
    question = FactoryBot.build(:question)
    answer = FactoryBot.build(:answer)
    question.answers << answer

    expect(question).to have_many(:answers).dependent(:destroy)
  end

end
