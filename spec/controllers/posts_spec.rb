require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  render_views

  let(:user) { User.create(name: 'Test User', posts_counter: 0) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get :index, params: { user_id: user.id }
      expect(response).to render_template('index')
    end

    it 'includes correct placeholder text in the response body' do
      get :index, params: { user_id: user.id }
      expect(response.body).to include('Here is the list of all posts')
    end
  end

  describe 'GET #show' do
    let(:post) { Post.create(author: user, title: 'Test Post', text: 'This is a test post') }

    it 'returns http success' do
      get :show, params: { user_id: user.id, id: post.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      get :show, params: { user_id: user.id, id: post.id }
      expect(response).to render_template('show')
    end

    it 'includes correct placeholder text in the response body' do
      get :show, params: { user_id: user.id, id: post.id }
      expect(response.body).to include('Here are the informations of a given post')
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get :new, params: { user_id: user.id }
      expect(response).to render_template('new')
    end

    it 'includes correct placeholder text in the response body' do
      get :new, params: { user_id: user.id }
      expect(response.body).to include('Here is the form to create a new post')
    end
  end

  describe 'POST #create' do
    it 'creates a new post' do
      post_params = { title: 'Test Post', text: 'This is a test post' }

      expect do
        post :create, params: { user_id: user.id, post: post_params }
      end.to change(Post, :count).by(1)

      expect(response).to redirect_to(user_post_path(user, assigns(:post)))
      expect(flash[:success]).to eq('Post created successfully')
    end

    it 'renders the new template on failure' do
      post_params = { title: '', text: '' }

      post :create, params: { user_id: user.id, post: post_params }

      expect(response).to render_template('new')
      expect(flash.now[:error]).to eq('Post could not be created')
    end
  end

  describe 'DELETE #destroy' do
    let(:post) { Post.create(author: user, title: 'Test Post', text: 'This is a test post') }

    it 'deletes the post' do
      delete :destroy, params: { user_id: user.id, id: post.id }

      expect(response).to redirect_to(user_posts_path(user))
      expect(Post.exists?(post.id)).to be_falsey
    end
  end
end
