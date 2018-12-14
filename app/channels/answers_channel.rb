class AnswersChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def follow(params)
    stream_from "question_#{params["id"]}: answers"
  end

end
