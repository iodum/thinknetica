require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :load_gon_user, unless: :devise_controller?
  
  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def load_gon_user
    gon.user = current_user if current_user
  end
end
