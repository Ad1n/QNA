ThinkingSphinx::Index.define :user, with: :active_record do
  # Fields
  indexes email

  # Attributes
  has confirmed_at, created_at, updated_at
end