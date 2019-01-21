require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:user) { create(:user) }

  after do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
  end

  it "send daily digest" do
    expect { DailyDigestJob.perform_now }.to have_enqueued_job.with("DailyMailer", "digest", "deliver_now", user)
  end
end
