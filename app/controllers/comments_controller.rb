class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [ :create]

  after_action :publish_comment, only: [:create]


  def create
    @comment = @commentable.comments.create(comment_params)
    @comment.user = current_user

    unless @comment.save
      flash[:error] = @comment.errors.full_messages
      render 'layouts/common/flash'
    end
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
      ApplicationController.render(
        json: {
          comment: @comment,
          commentable: @commentable
        }
      )
    )
  end
end
