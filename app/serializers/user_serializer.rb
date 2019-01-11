class UserSerializer < BaseSerializer
  attributes %i[id created_at updated_at email admin]
end
