class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  after_create :likes_count
  after_destroy :likes_count

  private

  # A method that updates the likes count for a post.
  def likes_count
    post.update(likes_count: post.likes.count)
  end
end
