class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_question, only: %i[new create show]
  before_action :set_answer, only: %i[destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if current_user.answers << @answer
      redirect_to question_path(@question)
    else
      redirect_to question_path(@question), notice: "Can not create answer."
    end
  end

  def destroy
    if current_user == @answer.user
      @answer.destroy
      redirect_to question_path(@answer.question)
    else
      redirect_to question_path(@answer.question), notice: "You are not the author of this answer."
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
    params.permit(:body)
  end
end
