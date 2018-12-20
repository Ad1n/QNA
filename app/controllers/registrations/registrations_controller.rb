# frozen_string_literal: true

class Registrations::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    resource.save
    resource.authorizations.create!(provider: params[:provider].keys[0], uid: params[:uid].keys[0]) if params.keys.include?("provider")

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        flash[:notice] = "Welcome #{params[:user][:email]}!"
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:uid, :provider, :sign_up, keys: [:attribute, :name, :surname])
  end
end
