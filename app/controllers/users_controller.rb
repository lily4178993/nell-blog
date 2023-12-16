class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    user_id = params[:id]
    @user = User.find_by(id: user_id)
    @posts = @user.recent_posts
    @post = Post.new
  end
end
