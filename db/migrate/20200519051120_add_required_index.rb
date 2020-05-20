class AddRequiredIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :topics, :name, unique: true
    add_index :users, :user_type
    add_index :users, :password_reset_token
    add_index :users, :password_token_expire_at
  end
end
