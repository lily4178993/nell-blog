class CommentsController < ApplicationController
  before_action :set_post, only: %i[new create destroy]

  def new
    @comment = @post.comments.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post
    if @comment.save
      flash[:success] = 'Comment created successfully'
      redirect_to user_post_path(@post.author, @post)
    else
      flash.now[:error] = 'Comment could not be created'
      render 'new'
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment.destroy
      flash[:success] = 'Comment deleted successfully'
    else
      flash.now[:error] = 'Comment could not be deleted'
    end
    redirect_to user_post_path(@post.author, @post)
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
