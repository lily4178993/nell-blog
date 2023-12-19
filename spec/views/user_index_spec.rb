# Path: spec/views/user_index_spec.rb
require 'rails_helper'
RSpec.describe 'users/index', type: :view do
  let(:user) { User.new(id: 1, name: 'John Doe', bio: 'Lorem ipsum', posts_counter: 5) }

  let(:other_users) do
    [User.new(id: 2, name: 'User1', bio: 'Bio1', posts_counter: 3),
     User.new(id: 3, name: 'User2', bio: 'Bio2', posts_counter: 7),
     User.new(id: 4, name: 'User3', bio: 'Bio3', posts_counter: 2)]
  end

  before do
    assign(:users, [user] + other_users)
    render
  end
  it 'displays the username of all other users' do
    other_users.each do |other_user|
      expect(rendered).to have_content(other_user.name)
    end
  end
  it 'displays the profile picture for each user' do
    (other_users + [user]).each do |current_user|
      # Adjust this expectation based on how your actual view renders the image
      expect(rendered).to have_selector("img[src*='#{current_user.photo.url}']") if current_user.photo&.attached?
    end
  end
  it 'displays the number of posts each user has written' do
    (other_users + [user]).each do |current_user|
      expect(rendered).to have_content("Number of posts: #{current_user.posts_counter}")
    end
  end
  it 'redirects to the show page when clicking on a user' do
    other_users.each do |current_user|
      expect(rendered).to have_link(current_user.name, href: user_path(current_user))
    end
  end
end
