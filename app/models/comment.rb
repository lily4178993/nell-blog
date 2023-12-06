class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  after_create :comments_count
  after_destroy :comments_count

  private

  # A method that updates the comments count for a post.
  def comments_count
    post.update(comments_count: post.comments.count)
  end
end
