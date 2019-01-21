module Subscribable
  extend ActiveSupport::Concern
  included do

    has_many :subscribes, as: :subscribable, dependent: :destroy

    def subscribe_by(user)
      subscribes.where(user: user)
    end

  end
end
