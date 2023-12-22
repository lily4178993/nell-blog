class PostsController < ApplicationController
  before_action :set_user, only: %i[index show new create destroy]
  load_and_authorize_resource only: %i[create destroy]

  def index
    @user = User.includes(posts: %i[comments likes]).find_by(id: params[:user_id])
    @post = Post.new
    @posts = @user.posts.includes(:author, :likes, :comments).all.paginate(page: params[:page],
                                                                           per_page: 2).order('created_at DESC')
    @like = @posts.present? ? Like.find_by(user: current_user, post: @posts.first) : nil
  end

  def show
    @post = @user.posts.includes(:comments, :likes).find_by(id: params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:author).order('created_at DESC')
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
    @post = @user.posts.find_by(id: params[:id])
    authorize! :destroy, @post
    if @post.destroy
      flash[:success] = 'Post deleted successfully'
    else
      flash.now[:error] = 'Post could not be deleted'
    end
    redirect_to user_posts_path(@user)
  end

  private

  def set_user
    @user = User.includes(posts: %i[comments likes]).find_by(id: params[:user_id])
  end

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
