class Subscribe < ApplicationRecord
  belongs_to :subscribable, polymorphic: true
  belongs_to :user
end
