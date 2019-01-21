require 'rails_helper'

RSpec.describe SubscribedQuestionJob, type: :job do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  after do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
  end

  it "send correct jobs to the queue" do
    SubscribedQuestionJob.perform_now([user, user2], answer)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.first[:job]).to eq SubscribedQuestionJob
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.second[:job]).to eq ActionMailer::DeliveryJob
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.second[:args]).to include("QuestionMailer",
                                                                                 "fresh_answer",
                                                                                 "deliver_now",
                                                                                 {"_aj_globalid"=>"gid://qna/User/#{user.id}"},
                                                                                 {"_aj_globalid"=>"gid://qna/Answer/#{answer.id}"})
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.third[:job]).to eq ActionMailer::DeliveryJob
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.third[:args]).to include("QuestionMailer",
                                                                                 "fresh_answer",
                                                                                 "deliver_now",
                                                                                {"_aj_globalid"=>"gid://qna/User/#{user2.id}"},
                                                                                {"_aj_globalid"=>"gid://qna/Answer/#{answer.id}"})
  end

  it 'queues the job' do
    expect { SubscribedQuestionJob.perform_now([user, user2], answer) }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(3)
  end
end
