require "application_responder"

class ApplicationController < ActionController::Base

  self.responder = ApplicationResponder


  before_action :gon_user, unless: :devise_controller?

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  private

  def gon_user
    gon.user_id = current_user&.id
    gon.user_signed_in = true if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { status: 403, message: exception } }
      format.js { render "shared/403", status: 403, message: exception }
    end
  end

  check_authorization unless: :devise_controller?
end
