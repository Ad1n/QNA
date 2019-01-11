class QuestionSerializer < BaseSerializer
  attributes %i[id short_title title body created_at updated_at]

  has_many :attachments
  has_many :answers
  has_many :comments
end
