class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription, only: :destroy
  before_action :load_question, only: :create

  respond_to :js

  def create
    authorize Subscription
    @question = Question.find(params[:question_id])
    respond_with(@subscription = @question.subscriptions.create(user: current_user))
  end

  def destroy
    authorize @subscription
    respond_with(@subscription.destroy)
  end

  private

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end