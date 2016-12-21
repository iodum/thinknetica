class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  protect_from_forgery with: :null_session

  protected

  private

  def context
    { current_user: current_user }
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_resource_owner
    @current_resource_owner ||= @current_user
  end
end
