module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    rendering(@votable.vote_up(current_user))
  end

  def vote_down
    rendering(@votable.vote_down(current_user))
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def rendering(result)
    if result[:success]
      render json: result.to_json
    else
      render json: result.to_json, status: :unprocessable_entity
    end
  end
end
