require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:user) { create(:user) }

  it "send daily digest" do
    ActiveJob::Base.queue_adapter = :test
    expect { DailyDigestJob.perform_now }.to have_enqueued_job.with("DailyMailer", "digest", "deliver_now", user)
  end
end
