class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:update, :destroy, :accept]
  before_action :check_author, only: [:update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answers_params)
    @answer.user = current_user

    unless @answer.save
      flash[:error] = @answer.errors.full_messages
      render 'layouts/common/flash'
    end
  end

  def update
    unless @answer.update(answers_params)
      flash[:error] = @answer.errors.full_messages
      render 'layouts/common/flash'
    end
  end

  def destroy
    unless @answer.destroy
      flash[:error] = @answer.errors.full_messages
      render 'layouts/common/flash'
    end
  end

  def accept
    if current_user.author_of?(@answer.question)
      @answer.accept
    else
      flash[:error] = "You haven't permission to update"
      render 'layouts/common/flash'
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.required(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def check_author
    unless current_user.author_of?(@answer)
      flash[:error] = "You haven't permission to update"
      render 'layouts/common/flash'
    end
  end
end
