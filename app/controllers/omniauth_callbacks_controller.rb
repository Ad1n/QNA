class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_with_app, only: %i[vkontakte github]

  def vkontakte; end

  def github; end

  private

  def sign_in_with_app
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
    elsif auth.info.email.nil?
      render "devise/email_confirm", locals: { resource: @user, uid: auth.uid, provider: auth.provider }
    end
  end
end