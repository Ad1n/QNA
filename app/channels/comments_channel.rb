class CommentsChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def follow(params)
    stream_from "Comments-questionRoom: #{params["question_room"]}"
  end
end
