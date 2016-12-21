class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]

  def index
    @question = Question.find(params[:question_id])
    respond_with @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: AnswerDetailSerializer
  end

  def create
    authorize Answer
    respond_with @question.answers.create(answers_params)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.required(:answer).permit(:body)
  end

end
