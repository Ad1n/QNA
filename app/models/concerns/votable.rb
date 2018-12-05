module Votable
  extend ActiveSupport::Concern
  included do

    has_many :votes, as: :votable, dependent: :destroy

    def rating
      votes.sum(:score)
    end

    def object_rating(user)
      votes.where(user: user).sum(:score)
    end

    def can_vote?(user, action_name)
      action_name == "vote" ? object_rating(user) == -1 || object_rating(user) == 0 : object_rating(user) == 1 || object_rating(user) == 0
    end

    def make_vote(user, action_name)
      action_name == "vote" ? @vote = votes.create!(score: 1, user: user) : @vote = votes.create!(score: -1, user: user)
    end

  end
end
