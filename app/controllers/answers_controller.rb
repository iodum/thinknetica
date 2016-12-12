class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:update, :destroy, :accept]

  after_action :publish_answer, only: [:create]

  respond_to :js

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answers_params.merge(user: current_user)))
  end

  def update
    @answer.update(answers_params) if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
  end

  def accept
    @answer.accept if current_user.author_of?(@answer.question)
    respond_with(@answer)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answers_params
    params.required(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "question_#{@question.id}",
      ApplicationController.render(
        json: {
          answer: @answer,
          question: @question,
          attachments: @answer.attachments
        }
      )
    )
  end
end
