class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_question, only: %i[create show choose_best_answer]
  before_action :set_answer, only: %i[destroy update choose_best_answer]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    unless @answer.save
      @question.answers.delete(@answer)
      @answers = @question.answers
    end
  end

  def choose_best_answer
    if current_user.author_of?(@question)
      @answer.make_choice
      redirect_to question_path(@question)
    end
  end

  def update
    if current_user.author_of?(@answer)
      @question = @answer.question
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
