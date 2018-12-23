# frozen_string_literal: true

class Registrations::RegistrationsController < Devise::RegistrationsController

  protected

  def build_resource(hash = {})
    super
    if params.keys.include?("provider")
      self.resource.authorizations.build(provider: params[:provider].keys[0], uid: params[:uid].keys[0])
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:uid, :provider, :sign_up, keys: [:attribute, :name, :surname])
  end
end
