class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]
  before_action :set_question, only: %i[create show]
  before_action :set_answer, only: %i[destroy update choose_best]
  after_action :publish_answer, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    unless @answer.save
      @question.answers.delete(@answer)
      @answers = @question.answers
    end

  end

  def choose_best
    if current_user.author_of?(@answer.question)
      @answer.make_choice
      redirect_to question_path(@answer.question)
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

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "answers",
        {
            answer: @answer,
            current_user_id: current_user.id,
            answer_attachments: @answer.attachments,
            question_user: @answer.question.user_id,
            answer_rating: @answer.rating
        }
    )
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
