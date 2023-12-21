class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # User can create posts and comments
    can :create, [Post, Comment]

    # User can read all posts and comments
    can :read, [Post, Comment]

    # User can destroy his own posts and comments
    can :destroy, [Post, Comment], author_id: user.id

    # User who is an admin can destroy any post and comment
    can :destroy, [Post, Comment] if user.role == 'admin'
  end
end
