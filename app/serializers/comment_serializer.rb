class CommentSerializer < BaseSerializer
  attributes %i[id body created_at updated_at commentable_type commentable_id user_id]
end
