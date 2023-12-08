require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_tom)
    @post = posts(:post_one)
    @comment = Comment.new(post: @post, user: @user, text: 'Hi Everyone!')
  end

  test 'should have associations' do
    assert_respond_to @comment, :user
    assert_respond_to @comment, :post
  end

  test 'text should not be blank' do
    @comment.text = ''
    assert_not @comment.valid?
    assert_equal ["can't be blank"], @comment.errors[:text]
  end

  test 'should update post comments count after create' do
    assert_difference('@post.comments_counter', 1) do
      @comment.save
    end
  end

  test 'should update post comments count after destroy' do
    @comment.save
    assert_difference('@post.comments_counter', -1) do
      @comment.destroy
    end
  end
end
