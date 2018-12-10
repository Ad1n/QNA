class AnswersChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def follow
    stream_from "answers"
  end
end
