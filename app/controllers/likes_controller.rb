class LikesController < ApplicationController
  def create
    @post = Post.find_by(id: params[:post_id])
    @like = Like.new(user: current_user, post: @post)
    if @like.save
      flash[:success] = 'Post liked successfully'
    else
      flash[:error] = 'Post could not be liked'
    end
    redirect_to user_post_path(@post.author, @post)
  end

  def destroy
    @post = Post.find_by(id: params[:post_id])
    @like = Like.find_by(user: current_user, post: @post)
    if @like.destroy
      flash[:success] = 'Post unliked successfully'
    else
      flash[:error] = 'Post could not be unliked'
    end
    redirect_to user_post_path(@post.author, @post)
  end
end
