require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :load_gon_user, unless: :devise_controller?

  private

  def load_gon_user
    gon.user = current_user if current_user
  end
end
