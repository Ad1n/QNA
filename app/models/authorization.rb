class Authorization < ApplicationRecord
  belongs_to :user

  def self.find_auth(auth)
    where(provider: auth.provider, uid: auth.uid.to_s).first
  end
end
