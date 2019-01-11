class AnswerSerializer < BaseSerializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :best_answer_id

  has_many :attachments
  has_many :comments
end
