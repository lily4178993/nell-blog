require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_lilly)
    @post = Post.new(author: @user, title: 'Sample Post', text: 'Just a sample post text')
  end

  test 'should have associations' do
    assert_respond_to @post, :author
    assert_respond_to @post, :comments
    assert_respond_to @post, :likes
  end

  test 'title should not be blank and should not exceed 250 characters' do
    @post.title = ''
    assert_not @post.valid?
    assert_equal ["can't be blank"], @post.errors[:title]

    @post.title = 'a' * 251
    assert_not @post.valid?
    assert_equal ['is too long (maximum is 250 characters)'], @post.errors[:title]

    @post.title = 'Valid Title'
    assert @post.valid?
  end

  test 'comments_counter should be an integer greater than or equal to zero' do
    @post.comments_counter = 'invalid'
    assert_not @post.valid?
    assert_equal ['is not a number'], @post.errors[:comments_counter]

    @post.comments_counter = -1
    assert_not @post.valid?
    assert_equal ['must be greater than or equal to 0'], @post.errors[:comments_counter]

    @post.comments_counter = 42
    assert @post.valid?
  end

  test 'likes_counter should be an integer greater than or equal to zero' do
    @post.likes_counter = 'invalid'
    assert_not @post.valid?
    assert_equal ['is not a number'], @post.errors[:likes_counter]

    @post.likes_counter = -1
    assert_not @post.valid?
    assert_equal ['must be greater than or equal to 0'], @post.errors[:likes_counter]

    @post.likes_counter = 42
    assert @post.valid?
  end

  test 'should return the 5 most recent comments of the post' do
    post = posts(:post_one)

    # Create posts dynamically
    7.times do |i|
      post.comments.create(text: "Comment #{i + 1}", created_at: (i + 1).days.ago)
    end

    # Ensure only the 5 most recent comments on a post are returned
    expected_comments = post.comments.order(created_at: :desc).limit(5)
    assert_equal expected_comments, post.recent_comments, 'Recent comments should match the expected list'
  end

  test 'should update user posts count after save' do
    Post.create(author: @user, title: 'New Post', text: 'Just a new sample post text')
    assert_equal @user.posts_counter, @user.reload.posts_counter,
                 'User posts_counter should be incremented after saving a new post'
  end

  test 'should update user posts count after destroy' do
    Post.create(author: @user, title: 'New Post', text: 'Just a new sample post text').destroy
    assert_equal @user.posts_counter, @user.reload.posts_counter,
                 'User posts_counter should be decremented after destroying a post'
  end
end
