class BestAnswer

  attr_reader :answer

  def initialize(answer)
    @answer = answer
  end

  def make_choice
    ActiveRecord::Base.transaction do
      answer.question.answers.update_all(best_answer_id: false)
      answer.question.answers.detect { |ans| ans.id == @answer.id }.update(best_answer_id: true)
    end
  end
end