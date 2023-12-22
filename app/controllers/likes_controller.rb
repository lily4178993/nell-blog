class LikesController < ApplicationController
  before_action :set_user_and_post
  before_action :set_like, only: %i[create destroy]
  load_and_authorize_resource only: %i[create destroy]

  def create
    @like = Like.new(user: @user, post: @post)

    if @like.save
      flash[:notice] = 'You liked this post'
    else
      flash[:alert] = 'The post could not be liked'
    end

    redirect_to user_post_path(@user, @post)
  end

  def destroy
    if @like.destroy
      flash[:notice] = 'You unliked this post'
    else
      flash[:alert] = 'The post could not be unliked'
    end

    redirect_to user_post_path(@user, @post)
  end

  private

  def set_user_and_post
    @user = User.find_by(id: params[:user_id])
    @post = Post.find_by(id: params[:post_id])
  end

  def set_like
    @like = Like.find_by(user: @user, post: @post)
  end
end
