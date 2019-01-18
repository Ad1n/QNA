class Answer < ApplicationRecord
  after_save do |answer|
    @subscribed_users = answer.question.subscribes.map(&:user)
    SubscribedQuestionJob.perform_later(@subscribed_users, answer)
  end

  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :sort_from_best_answer, -> { order(best_answer_id: :desc) }

  def make_choice
    ActiveRecord::Base.transaction do
      question.answers.update_all(best_answer_id: false)
      update!(best_answer_id: true)
    end
  end
end
