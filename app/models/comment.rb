class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  after_create :comments_count
  after_destroy :comments_count

  # Validation: Comment text must not be blank.
  validates :text, presence: true

  private

  # A method that updates the comments count for a post.
  def comments_count
    post.update(comments_counter: post.comments.count)
  end
end
