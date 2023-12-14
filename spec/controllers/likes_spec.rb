require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { User.create(name: 'Test User', posts_counter: 0) }
  let(:post) { Post.create(author: user, title: 'Test Post', text: 'This is a test post') }

  describe 'POST #create' do
    it 'creates a new like' do
      like = Like.create(user_id: user.id, post_id: post.id)
      expect {
        post.reload
      }.to change { post.likes_counter }.by(1)

      flash[:success] = 'Post liked successfully'
      redirect_to(user_post_path(post.author, post))
    end

    it 'renders an error message on failure' do
      allow_any_instance_of(Like).to receive(:save).and_return(false)

      flash[:error] = 'Post could not be liked'
      redirect_to(user_post_path(post.author, post))
    end
  end

  describe 'DELETE #destroy' do
    let!(:like) { Like.create(user: user, post: post) }

    it 'destroys the like' do
      expect {
        delete :destroy, params: { user_id: user.id, post_id: post.id, id: like.id }
      }.to change(Like, :count).by(-1)

      flash[:success] = 'Post unliked successfully'
      redirect_to(user_post_path(post.author, post))
    end

    it 'renders an error message on failure' do
      allow_any_instance_of(Like).to receive(:destroy).and_return(false)

      delete :destroy, params: { user_id: user.id, post_id: post.id, id: like.id }

      flash[:error] = 'Post could not be unliked'
      redirect_to(user_post_path(post.author, post))
    end
  end
end
