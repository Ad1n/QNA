class CommentsController < ApplicationController

  before_action :set_commentable, only: %i[create]
  after_action :broadcast_comments, only: %i[create]

  authorize_resource

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
    ActionCable.server.broadcast "questions/#{@question_id}/comments", comment: @comment
  end

  def set_commentable
    @commentable = find_commentable
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
        @question_id = set_question_id(@commentable)
        return @commentable
      end
    end
    nil
  end

  def set_question_id(klass)
    klass.respond_to?(:question) ? klass.question.id : klass.id
  end

  def comments_params
    params.require(:comment).permit(:body)
  end

end
