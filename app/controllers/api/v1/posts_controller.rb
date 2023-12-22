class Api::V1::PostsController < ApplicationController
  def index
    @posts = current_user.posts
    
    if @posts.present?
      render json: { success: true, user: { id: current_user.id, posts: @posts } }
    else
      render json: { success: false, message: 'No posts found' }, status: :not_found
    end
  end
end