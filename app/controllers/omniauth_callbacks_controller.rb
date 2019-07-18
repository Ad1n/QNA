class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_with_app, only: %i[vkontakte github]

  attr_reader :auth

  def vkontakte; end

  def github; end

  private

  def sign_in_with_app
    @auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

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
end