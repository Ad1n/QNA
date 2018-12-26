class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]
  before_action :set_question, only: %i[create show]
  before_action :set_answer, only: %i[destroy update choose_best]
  after_action :broadcast_answer, only: %i[create]

  respond_to :js

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_with(@question, @answer.save)
  end

  def choose_best
    @answer.make_choice
    redirect_to question_path(@answer.question)
  end

  def update
    @answer.update(answer_params)
    respond_with(@question = @answer.question, @answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private

  def broadcast_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast "questions/#{@answer.question.id}/answers", {
        answer: @answer,
        answer_attachments: @answer.attachments,
        question_user: @question.user_id,
        answer_rating: @answer.rating,
        question_id: @question.id
    }
  end

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
