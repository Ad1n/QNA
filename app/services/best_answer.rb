class BestAnswer

  attr_reader :question, :answer

  def initialize(question, answer)
    @question = question
    @answer = answer
  end

  def make_choice
    set_best_answer
  end

  private

  def set_best_answer
    question.answers.each do |answer|
      answer == @answer ? self.answer.update(best_answer_id: answer.id) : answer.update(best_answer_id: 0)
    end
  end

end