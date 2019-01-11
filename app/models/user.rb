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

  scope :all_except, ->(user) { where.not(id: user) }

  attr_reader :auth, :created_user

  def author_of?(object)
    id == object.user_id
  end

  def self.find_for_oauth(auth)
    @auth = auth
    create_default_user_n_auth if !Authorization.find_auth(auth).present? && app_have_not_returned_email
    authorization = Authorization.find_auth(auth)
    return authorization.user if authorization

    email = auth.info[:email]
    return @created_user unless email

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

  def self.create_default_user_n_auth
    @created_user = User.new(email: "unconfirmed@user.wait", password: "12345678")
    @created_user.skip_confirmation!
    @created_user.save!
    @created_user.authorizations.create!(provider: @auth.provider, uid: @auth.uid)
  end

  def self.app_have_not_returned_email
    %i[github].include?(@auth.provider)
  end
end
