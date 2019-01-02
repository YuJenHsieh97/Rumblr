class CreateUsers < ActiveRecord::Migration[5.0]
    def up
      create_table :users do |u|
        u.string :pic
        u.string :firstName
        u.string :lastName
        u.string :email
        u.string :password

      end
    end
  
    def down
      drop_table :users
    end
  end