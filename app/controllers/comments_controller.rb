class CommentsController < ApplicationController
  before_action :set_post, only: %i[new create destroy]
  load_and_authorize_resource only: %i[create destroy]

  def new
    @comment = @post.comments.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post
    if @comment.save
      flash[:notice] = 'Your comment has been added'
      redirect_to user_post_path(@post.author, @post)
    else
      flash.now[:alert] = 'Error while adding your comment'
      render 'new'
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    authorize! :destroy, @comment
    if @comment.destroy
      flash[:notice] = 'The comment was deleted successfully'
    else
      flash.now[:alert] = 'The comment could not be deleted'
    end
    redirect_to user_post_path(@post.author, @post)
  end

  private

  def set_post
    @post = Post.includes(:comments).find_by(id: params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
