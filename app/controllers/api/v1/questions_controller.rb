class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionDetailSerializer
  end

  def create
    authorize Question
    respond_with current_resource_owner.questions.create(questions_params)
  end

  private

  def questions_params
    params.required(:question).permit(:title, :body)
  end

end
