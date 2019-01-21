class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :build_answer, only: %i[show]
  before_action :check_subscribe, only: %i[show]
  after_action :publish_question, only: %i[create]

  respond_to :html, :js

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question_id = @question.id
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def check_subscribe
    @subscribe = @question.subscribes.first
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      "questions",
      ApplicationController.render_with_signed_in_user(
        current_user,
        partial: "questions/question",
        locals: { question: @question }
      )
    )
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
