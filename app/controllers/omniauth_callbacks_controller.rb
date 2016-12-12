class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_provider

  def facebook
  end

  def twitter
  end

  def failure
    redirect_to root_path
  end

  private

  def oauth_provider
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      if @user.email == User.get_email(auth)
        session['devise.temp_user_id'] = @user.id
        redirect_to edit_user_email_url
      else
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
      end
    else
      session['devise.user_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
