require "rails_helper"

RSpec.describe QuestionMailer, type: :mailer do
  describe "fresh_answer" do

    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { QuestionMailer.fresh_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Fresh answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
      expect(mail.body.encoded).to include answer.body
      expect(mail.body.encoded).to include user.email
    end
  end
end
