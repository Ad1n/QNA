require 'rails_helper'

RSpec.describe SubscribedQuestionJob, type: :job do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it "send new answer to all subscribers" do
    ActiveJob::Base.queue_adapter = :test
    expect { SubscribedQuestionJob.perform_later([user, user2], answer) }.to have_enqueued_job.with([user, user2], answer)
  end
end
