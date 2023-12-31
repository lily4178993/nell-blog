class Api::V1::PostsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def index
    @user = User.find_by(id: params[:user_id])
    @posts = @user.posts

    if @posts.present?
      render json: { success: true, user: { user_id: @user.id, name: @user.name, posts: @posts } }
    else
      render json: { success: false, message: 'No posts found' }, status: :not_found
    end
  end
end
