class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  def destroy
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
    else
      flash[:error] = @attachment.errors.full_messages
      render 'layouts/common/flash'
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

end
