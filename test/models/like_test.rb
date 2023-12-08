require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_tom)
    @post = posts(:post_one)
    @like = Like.new(user: @user, post: @post)
  end

  test 'should have associations' do
    assert_respond_to @like, :user
    assert_respond_to @like, :post
  end

  test 'should update likes count for a post after create' do
    assert_difference('@post.likes_counter', 1) do
      @like.save
    end
  end

  test 'should update likes count for a post after destroy' do
    @like.save

    assert_difference('@post.likes_counter', -1) do
      @like.destroy
    end
  end
end
