class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.includes(posts: [:comments, :likes]).find_by(id: params[:id])
    @posts = @user.recent_posts
    @post = Post.new
    @like = @posts.present? ? Like.find_by(user: current_user, post: @posts.first) : nil
  end
end
