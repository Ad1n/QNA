class Question < ApplicationRecord
  include Votable
  include Commentable
  include Subscribable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def subscribe_by(user)
    subscribes.where(user: user)
  end

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
