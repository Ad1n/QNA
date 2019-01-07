class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_with_app, only: %i[vkontakte github]

  attr_reader :auth

  def vkontakte; end

  def github; end

  private

  def sign_in_with_app
    @auth = request.env['omniauth.auth']
    create_default_user_n_auth if !Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first.present? && app_have_not_returned_email
    @user = User.find_for_oauth(auth, @default_user)

    if @user.persisted?
      if @user.email == "unconfirmed@user.wait"
        sign_in @user
        render "devise/email_confirm", locals: { resource: @user }
      else
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
      end
    else
      redirect_to root_path, notice: "Can not create user. Try later"
    end

  end

  def create_default_user_n_auth
    @default_user = User.new(email: "unconfirmed@user.wait", password: "12345678")
    @default_user.skip_confirmation!
    @default_user.save!
    @default_user.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def app_have_not_returned_email
    %w[github].include?(action_name)
  end
end