class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :author, foreign_key: { to_table: :users, name: 'author_id' }
      t.string :title
      t.text :text
      t.integer :commentsCounter, default: 0
      t.integer :likesCounter, default: 0

      t.timestamps
    end
  end
end
