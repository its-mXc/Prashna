class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :user_type, default: 'user'
      t.integer :credit_balance, default: 0
      t.integer :followers_count, default: 0

      t.timestamps
    end
  end
end
