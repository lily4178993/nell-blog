class PostsController < ApplicationController
  def index
    @user = User.find_by(id: params[:user_id])
    @posts = @user.posts.all
  end

  def show
    @user = User.find_by(id: params[:user_id])
    @post = @user.posts.find_by(id: params[:id])
    @comments = @user.posts.all
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @post = @user.posts.new
  end

  def create
    @post = Post.new(params.require(:post).permit(:title, :text))
    current_user = User.find_by(id: params[:user_id])
    @post.author = current_user
    if @post.save
      flash[:success] = 'Post created successfully'
      redirect_to user_post_path(current_user, @post)
    else
      flash.now[:error] = 'Post could not be created'
      render 'new'
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to user_posts_path
  end
end
