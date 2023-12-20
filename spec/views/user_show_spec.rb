require 'rails_helper'

RSpec.feature 'User show page', type: :feature do
  let(:user) { User.create(id: 1, name: 'John Doe', photo: 'https://unsplash.com/photos/F_-0BxGuVvo', bio: 'Lorem ipsum', posts_counter: 5) }
  let!(:posts) do
    (1..3).map do |i|
      Post.create(id: i, author: user, title: "Title #{i}", text: "Body #{i}")
    end
  end

  before do
    visit user_path(user)
  end

  scenario 'User see user details and posts' do
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.bio)
    expect(page).to have_css("img[src*='#{user.photo}']")
    expect(page).to have_content("Number of posts: #{user.posts_counter}")
    posts.each do |post|
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.text)
    end
  end

  scenario "User can view 'See all posts' button and click to redirected to post's index page" do
    expect(page).to have_link('See all posts')
    click_link 'See all posts'
    expect(current_path).to eq(user_posts_path(user))
  end

  scenario 'User can view a post show page when click on a post title' do
    click_link posts.first.title
    expect(current_path).to eq(user_post_path(user, posts.first))
  end
end
