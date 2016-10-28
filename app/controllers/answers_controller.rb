class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answers_params)
    @answer.user = current_user
    @user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully added.'
    else
      flash[:error] = @answer.errors.full_messages
      render :new
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.required(:answer).permit(:body)
  end
end
