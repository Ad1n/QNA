class QuestionMailer < ApplicationMailer
  def fresh_answer(user, answer)
    @answer = answer
    mail to: user.email
  end
end
