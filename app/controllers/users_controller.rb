class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.recent_posts
    @post = @user.posts.first
    @like = @post.present? ? Like.find_by(user: current_user, post: @post) : nil
  end
end
