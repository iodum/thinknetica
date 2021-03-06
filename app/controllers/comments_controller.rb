class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  after_action :publish_comment, only: [:create]

  respond_to :js

  def create
    respond_with(authorize @comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private

  def load_commentable
    klass = [Question, Answer].detect { |obj| params["#{obj.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end

  def publish_comment
    question_id = (@comment.commentable_type == 'Question') ? @comment.commentable_id : @comment.commentable.question_id
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments_#{question_id}",
      {
          comment: @comment,
          commentable: @commentable
      }.to_json
    )
  end
end
