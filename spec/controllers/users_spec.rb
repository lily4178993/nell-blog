require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  describe 'GET #index' do
    before do
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end

    it 'includes correct placeholder text in the response body' do
      expect(response.body).to include('Here is the list of all users')
    end
  end

  describe 'GET #show' do
    let(:user) { User.create(name: 'Test User', posts_counter: 0) }

    before do
      get :show, params: { id: user.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end

    it 'includes correct placeholder text in the response body' do
      expect(response.body).to include('Here are the informations of a given user')
    end
  end
end
