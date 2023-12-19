require 'rails_helper'

RSpec.feature 'Post show page', type: :feature do
  before do
    @user1 = User.create(id: 1, name: 'Bob', photo: 'testPhoto1.jpg', bio: 'Teacher from Mexico.',
                         posts_counter: 0)
    @user2 = User.create(id: 2, name: 'Lilly', photo: 'testPhoto2.png', bio: 'Teacher from Poland.',
                         posts_counter: 0)

    @post1 = Post.create(id: 1, author: @user1, title: 'First Post', text: 'This is a test post.', comments_counter: 0,
                         likes_counter: 0)

    Comment.create(id: 1, user: @user2, post: @post1, text: 'This is a test comment.')
    Comment.create(id: 2, user: @user1, post: @post1, text: 'Another test comment.')

    visit user_post_path(@user1, @post1)
  end

  context 'when displaying post information' do
    it 'shows the post details' do
      expect(page).to have_content(@post1.title)
      expect(page).to have_content("by #{@user1.name}")
      expect(page).to have_content("Comments: #{@post1.comments_counter}")
      expect(page).to have_content("Likes: #{@post1.likes_counter}")
      expect(page).to have_content(@post1.text)
    end
  end

  context 'when displaying comments information' do
    it 'shows the details of each comment' do
      comments = Comment.where(post: @post1)
      comments.each do |comment|
        expect(page).to have_content(comment.user.name)
        expect(page).to have_content(comment.text)
      end
    end
  end
end
