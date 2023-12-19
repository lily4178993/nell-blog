class PostsController < ApplicationController
  before_action :set_user, only: %i[index show new create]

  def index
    @user = User.includes(posts: [:comments, :likes]).find_by(id: params[:user_id])
    @post = Post.new
    @posts = @user.posts.includes(:likes, :comments).all.paginate(page: params[:page], per_page: 2)
    @like = @posts.present? ? Like.find_by(user: current_user, post: @posts.first) : nil
  end

  def show
    @post = @user.posts.includes(:comments, :likes).find_by(id: params[:id])
    @comment = Comment.new
    @comments = @post.comments
    @like = Like.find_by(user: @user, post: @post)
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @post = @user.posts.new
  end

  def create
    @post = @user.posts.new(post_params)
    @post.author = @user
    if @post.save
      flash[:success] = 'Post created successfully'
      redirect_to user_post_path(@user, @post)
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

  private

  def set_user
    @user = User.includes(posts: [:comments, :likes]).find_by(id: params[:user_id])
  end

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
