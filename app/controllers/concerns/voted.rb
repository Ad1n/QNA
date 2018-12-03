module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote unvote]
  end

  def vote
    if @votable.object_rating(current_user) == -1 || @votable.object_rating(current_user) == 0
      voted_action
    end
  end

  def unvote
    if @votable.object_rating(current_user) == 1 || @votable.object_rating(current_user) == 0
      voted_action
    end
  end

  private

  def voted_action
    unless current_user.nil?
      respond_to do |format|
        if send("make_#{action_name}")
          format.json { render json: { rating: @votable.rating } }
        else
          format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity}
        end
      end
    end
  end

  def make_vote
    @vote = current_user.votes.create!(score: 1, votable: @votable)
  end

  def make_unvote
    @vote = current_user.votes.create!(score: -1, votable: @votable)
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
