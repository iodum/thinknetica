class RegistrationsController < Devise::RegistrationsController
  before_action :load_user, only: [:edit_email, :update_email]

  def edit_email
  end

  def update_email
    if @user && @user.update(email: user_params[:email])
      redirect_to root_path
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
    else
      redirect_to edit_user_email_path
    end
  end

  private

  def user_params
    params.required(:user).permit(:email)
  end

  def load_user
    @user = User.find(session['devise.temp_user_id'])
  end
end
