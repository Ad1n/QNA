class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:vkontakte, :github]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def self.find_for_oauth(auth, created_user = nil)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return created_user unless email

    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
