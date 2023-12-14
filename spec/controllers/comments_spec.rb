require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views

  let(:user) { User.create(name: 'Test User', posts_counter: 0) }
  let(:post) { Post.create(author: user, title: 'Test Post', text: 'This is a test post') }

  describe 'GET #new' do
    before do
      get :new, params: { user_id: user.id, post_id: post.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      expect(response).to render_template('new')
    end

    it 'assigns a new comment' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  end

  describe 'POST #create' do
    let(:invalid_comment_params) { { comment: { text: '' } } }

    context 'with valid parameters' do
      it 'creates a new comment' do
        Comment.create(post_id: post.id, user_id: user.id, text: 'This is a comment.')
        expect {
          post.reload
        }.to change { post.comments_counter }.by(1)

        flash[:success] = 'Comment created successfully'
        redirect_to(user_post_path(post.author, post))
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template on failure' do
        Comment.create(post_id: post.id, user_id: user.id, text: '')
        expect {
          post.reload
        }.to change { post.comments_counter }.by(0)

        flash.now[:error] = 'Comment could not be created'

        get :new, params: { user_id: user.id, post_id: post.id }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { Comment.create(user: user, post: post, text: 'This is a comment.') }

    it 'destroys the comment' do
      expect {
        delete :destroy, params: { user_id: user.id, post_id: post.id, id: comment.id }
      }.to change(Comment, :count).by(-1)

      flash[:success] = 'Comment deleted successfully'
      redirect_to(user_post_path(post.author, post))
    end

    it 'renders an error message on failure' do
      allow_any_instance_of(Comment).to receive(:destroy).and_return(false)

      delete :destroy, params: { user_id: user.id, post_id: post.id, id: comment.id }

      flash[:error] = 'Comment could not be deleted'
      redirect_to(user_post_path(post.author, post))
    end
  end
end
