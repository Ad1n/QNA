class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[create]
  before_action :load_answer, only: %i[show]
  authorize_resource

  def show
    respond_with @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash[:notice] = 'Answer was successfully created.' if @answer.save
    respond_with(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
