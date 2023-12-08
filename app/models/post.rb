class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :comments
  has_many :likes

  after_save :user_posts_count
  after_destroy :user_posts_count

  # Validation: Title must not be blank and should not exceed 250 characters.
  validates :title, presence: true, length: { maximum: 250 }

  # Validation: comments_counter must be an integer greater than or equal to zero.
  validates :comments_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Validation: likes_counter must be an integer greater than or equal to zero.
  validates :likes_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # A method which returns the 5 most recent comments for a given post.
  def recent_comments
    comments.order(created_at: :desc).limit(5)
  end

  private

  # A method that updates the posts count for a user.
  def user_posts_count
    author.update(posts_counter: author.posts.count)
  end
end
