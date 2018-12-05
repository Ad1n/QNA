module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote unvote]
  end

  def vote
    if current_user && @votable.can_vote?(current_user, action_name)
      respond_to do |format|
        if @votable.make_vote(current_user, action_name)
          format.json { render json: { rating: @votable.rating } }
        else
          format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity}
        end
      end
    end
  end

  def unvote
    if current_user && @votable.can_vote?(current_user, action_name)
      respond_to do |format|
        if @votable.make_vote(current_user, action_name)
          format.json { render json: { rating: @votable.rating } }
        else
          format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity}
        end
      end
    end
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
