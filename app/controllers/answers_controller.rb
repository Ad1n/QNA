class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_question, only: %i[create show]
  before_action :set_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    unless @answer.save
      @question.answers.delete(@answer)
      @answers = @question.answers
    end

  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question)
    else
      redirect_to question_path(@answer.question), notice: "You are not the author of this answer"
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
    params.require(:answer).permit(:body)
  end
end
