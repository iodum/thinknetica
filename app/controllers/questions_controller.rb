class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.new
    # @answer = @question.answers.build
    # @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.create(questions_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:error] = @question.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(questions_params)
      redirect_to @question
    else
      flash[:error] = @question.errors.full_messages
      render 'layouts/common/flash'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    end
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.required(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
