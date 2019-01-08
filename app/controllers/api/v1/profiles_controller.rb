class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  authorize_resource class: "User"
  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with all_users
  end

  protected

  def all_users
    @users = User.all_except(current_resource_owner)
  end

  def current_resource_owner
    @current_user_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
