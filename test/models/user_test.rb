require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should have associations' do
    assert_respond_to User.new, :posts
    assert_respond_to User.new, :comments
    assert_respond_to User.new, :likes
  end

  test 'name should not be blank' do
    user = User.new(name: '')
    assert_not user.valid?
    assert_equal ["can't be blank"], user.errors[:name]
  end

  test 'posts_counter should be an integer greater than or equal to zero' do
    user = User.new(name: 'Mariam', posts_counter: 'invalid')
    assert_not user.valid?
    assert_equal ['is not a number'], user.errors[:posts_counter]

    user.posts_counter = -1
    assert_not user.valid?
    assert_equal ['must be greater than or equal to 0'], user.errors[:posts_counter]

    user.posts_counter = 42
    assert user.valid?
  end

  test 'should return the 3 most recent posts of user Tom' do
    user = users(:user_tom)

    # Create posts dynamically
    5.times do |i|
      user.posts.create(text: "Post #{i + 1}", created_at: (i + 1).days.ago)
    end

    # Ensure only the 3 most recent posts are returned
    expected_posts = user.posts.order(created_at: :desc).limit(3)
    assert_equal expected_posts, user.recent_posts
  end
end
