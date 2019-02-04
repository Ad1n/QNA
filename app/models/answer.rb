class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  after_save :digest_for_subscribers

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :sort_from_best_answer, -> { order(best_answer_id: :desc) }

  def make_choice
    ActiveRecord::Base.transaction do
      question.answers.update_all(best_answer_id: false)
      update!(best_answer_id: true)
    end
  end

  private

  def digest_for_subscribers
    @subscribed_users = question.subscribes.map(&:user)
    SubscribedQuestionJob.perform_later(@subscribed_users, self)
  end
end
