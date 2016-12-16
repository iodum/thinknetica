class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]
  after_action :publish_question, only: [:create]

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    authorize Question
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def edit
  end

  def update
    authorize @question
    @question.update(questions_params)
    respond_with(@question)
  end

  def destroy
    authorize @question
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.required(:question).permit(:title, :body,
                                      attachments_attributes: [:file, :id, :_destroy])
  end

  def build_answer
    @answer = Answer.new
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
