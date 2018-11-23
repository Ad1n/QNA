class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sort_from_best_answer, -> { order(best_answer_id: :desc) }
end
