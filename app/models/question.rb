class Question < ApplicationRecord
  include Votable
  include Commentable
  include Subscribable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  after_save :auto_subscribe

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  private

  def auto_subscribe
    subscribes.create!(user: user)
  end
end
