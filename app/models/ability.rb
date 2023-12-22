class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # User can create posts, comments, and likes
    can :create, [Post, Comment, Like]

    # User can read all posts, comments, and users
    can :read, [Post, Comment, User]

    # User can destroy his own likes
    can :destroy, Like, user_id: user.id

    # User can destroy his own posts and comments
    can :destroy, [Post, Comment], author_id: user.id

    # User who is an admin can destroy any post and comment
    can :destroy, [Post, Comment] if user.role == 'admin'
  end
end
