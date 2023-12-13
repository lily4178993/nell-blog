class CommentsController < ApplicationController
  def new
    @post = Post.find_by(id: params[:post_id])
    @comment = @post.comments.new
  end

  def create
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.new(params.require(:comment).permit(:text))
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
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.find_by(id: params[:id])
    if @comment.destroy
      flash[:success] = 'Comment deleted successfully'
    else
      flash.now[:error] = 'Comment could not be deleted'
    end
    redirect_to user_post_path(@post.author, @post)
  end
end
