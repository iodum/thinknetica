require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :load_gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { errors: exception.message.to_s }, status: :forbidden }
      format.js { head :forbidden }
    end
  end

  private

  def load_gon_user
    gon.user = current_user if current_user
  end
end
