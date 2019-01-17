module Subscribable
  extend ActiveSupport::Concern
  included do

    has_many :subscribes, as: :subscribable, dependent: :destroy

  end
end
