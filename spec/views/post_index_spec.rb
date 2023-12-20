require 'rails_helper'

RSpec.feature 'User posts index page', type: :feature do
  include ActionView::Helpers::TextHelper

  let(:user) { User.create(name: 'John Doe', photo: 'https://unsplash.com/photos/F_-0BxGuVvo', bio: 'Lorem ipsum', posts_counter: 3) }

  before do
    3.times do |i|
      post = Post.create(author: user, title: "Test Post #{i}", text: 'This is a test post.')
      3.times { Comment.create(user:, post:, text: 'This is a test comment.') }
    end
    visit user_posts_path(user)
  end

  scenario 'User sees user details on index page' do
    expect(page).to have_css("img[src*='#{user.photo}']")
    expect(page).to have_content(user.name)
    expect(page).to have_content("Number of posts: #{user.posts_counter}")
  end

  scenario 'User sees post details on index page' do
    expect(page).to have_content(Post.first.title)
    expect(page).to have_content(Post.first.text)
    expect(page).to have_content(Post.first.comments_counter)
    expect(page).to have_content(Post.first.likes_counter)
    expect(page).to have_content(Comment.first.text)
  end

  scenario 'User sees pagination section on index page to see more posts' do
    expect(page).to have_css('.post-container', count: 2)
  end

  scenario "User can redirect to a post's show page, when click" do
    post_to_click = Post.order(created_at: :desc).first
    find('a', text: post_to_click.title, match: :first).click
    expect(current_path).to eq(user_post_path(user, post_to_click))
  end
end
