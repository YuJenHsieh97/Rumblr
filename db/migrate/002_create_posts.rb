class CreatePosts < ActiveRecord::Migration[5.0]
    def up
      create_table :posts do |p|
        p.string :image
        p.string :text
        p.integer :user_id
      end
    end

    def down
      drop_table :posts
    end
  end