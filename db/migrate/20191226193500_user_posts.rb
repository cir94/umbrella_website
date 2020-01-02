class UserPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :time
      t.string :post
  end
end
end
