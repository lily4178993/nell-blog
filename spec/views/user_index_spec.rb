# Path: spec/views/user_index_spec.rb
require 'rails_helper'
RSpec.describe 'users/index', type: :view do
  let(:user) { User.create(id: 1, name: 'John Doe', bio: 'Lorem ipsum', posts_counter: 5) }

  let(:other_users) do
    (2..4).map do |i|
      User.create(id: i, name: "User#{i}", bio: "Bio#{i}", posts_counter: i * 2)
    end
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
