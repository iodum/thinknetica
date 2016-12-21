class Api::V1::AnswersController < Api::V1::BaseController

  def index
    @question = Question.find(params[:question_id])
    respond_with @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: AnswerDetailSerializer
  end

  private

  def answers_params
    params.required(:answer).permit(:body)
  end

end