class CommentsController < ApplicationController

  before_action :set_commentable, only: %i[create]
  after_action :broadcast_comments, only: %i[create]

  def create
    @comment = @commentable.comments.new(comments_params)
    @comment.user = current_user

    if current_user
      respond_to do |format|
        if @comment.save
          format.json { render json: { comment: @comment } }
        else
          format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def broadcast_comments
    return if @comment.errors.any?
    ActionCable.server.broadcast "Comments-questionRoom: #{@question_room}", comment: @comment
  end

  def set_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
      @question_room = params[:question_id]
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
      @question_room = @commentable.question.id
    end
  end

  def comments_params
    params.require(:comment).permit(:body)
  end

end
