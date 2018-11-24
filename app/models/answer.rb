class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sort_from_best_answer, -> { order(best_answer_id: :desc) }

  def make_choice
    ActiveRecord::Base.transaction do
      question.answers.update_all(best_answer_id: false)
      update!(best_answer_id: true)
    end
  end
end
