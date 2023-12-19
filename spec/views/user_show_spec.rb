require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:user) { User.create(id: 1, name: 'John Doe', photo: 'https://unsplash.com/photos/F_-0BxGuVvo', bio: 'Lorem ipsum', posts_counter: 5) }
  let!(:posts) do
    [Post.create(id: 1, author: user, title: 'Title 1', text: 'Body 1'),
     Post.create(id: 2, author: user, title: 'Title 2', text: 'Body 2'),
     Post.create(id: 3, author: user, title: 'Title 3', text: 'Body 3')]
  end

  before do
    assign(:user, user)
    assign(:posts, posts)
    assign(:post, Post.new) # Assign a new instance of Post to @post
    render
  end

  it 'displays user details' do
    expect(rendered).to have_content(user.name)
    expect(rendered).to have_content(user.bio)
    expect(rendered).to have_css("img[src*='#{user.photo}']")
    expect(rendered).to have_content("Number of posts: #{user.posts_counter}")
  end

  it 'displays user posts' do
    posts.each do |post|
      expect(rendered).to have_content(post.title)
      expect(rendered).to have_content(post.text) # Assuming 'text' is the attribute for post body
    end
  end
end
