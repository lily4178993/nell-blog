require 'rails_helper'

RSpec.feature 'User posts index page', type: :feature do
  include ActionView::Helpers::TextHelper

  let(:user) { User.create(name: 'John Doe', photo: 'https://unsplash.com/photos/F_-0BxGuVvo', bio: 'Lorem ipsum', posts_counter: 5) }

  scenario 'User sees user details on index page' do
    visit user_posts_path(user)

    expect(page).to have_css("img[src*='#{user.photo}']")
    expect(page).to have_content(user.name)
    expect(page).to have_content("Number of posts: #{user.posts_counter}")
  end

  scenario 'User sees post details on index page' do
    post = Post.create(author: user, title: 'Test Post', text: 'This is a test post.')

    visit user_posts_path(user)

    expect(page).to have_content(post.title)
    expect(page).to have_content(truncate(post.text, length: 100))

    expect(page).to have_content("Comments: #{post.comments_counter}")
    expect(page).to have_content("Likes: #{post.likes_counter}")
  end

  scenario 'User sees pagination section on index page' do
    3.times { Post.create(author: user, title: 'Test Post', text: 'This is a test post.') }

    visit user_posts_path(user)

    expect(page).to have_css('.post-container', count: 2)
  end

  scenario 'User redirects to post show page when clicking on a post' do
    post = Post.create(author: user, title: 'Test Post', text: 'This is a test post.')

    visit user_posts_path(user)

    click_link post.title
    expect(current_path).to eq(user_post_path(user, post))
  end
end
