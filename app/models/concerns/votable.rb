module Votable
  extend ActiveSupport::Concern
  included do

    has_many :votes, as: :votable, dependent: :destroy

    def rating
      votes.pluck(:score).inject(0, :+)
    end

    def object_rating(user = User.all)
      votes.where(user: user).pluck(:score).inject(0, :+)
    end
  end
end
