class SubscribedQuestionJob < ApplicationJob
  queue_as :default

  def perform(users, answer)
    users.each do |user|
      QuestionMailer.fresh_answer(user, answer).deliver_later
    end
  end
end
