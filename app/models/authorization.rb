class Authorization < ApplicationRecord
  belongs_to :user

  scope :find_auth, ->(auth) { where(provider: auth.provider, uid: auth.uid.to_s).first }
end
