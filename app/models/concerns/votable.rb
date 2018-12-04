module Votable
  extend ActiveSupport::Concern
  included do

    has_many :votes, as: :votable, dependent: :destroy

    #Votement business-logic  =======================================
    def rating
      votes.sum(:score)
    end

    def object_rating(user)
      votes.where(user: user).sum(:score)
    end

    def can_vote?(user)
      object_rating(user) == -1 || object_rating(user) == 0
    end

    def can_unvote?(user)
      object_rating(user) == 1 || object_rating(user) == 0
    end

    def make_vote(user)
      @vote = user.votes.create!(score: 1, votable: self)
    end

    def make_unvote(user)
      @vote = user.votes.create!(score: -1, votable: self)
    end
    #==================================================================
  end
end
