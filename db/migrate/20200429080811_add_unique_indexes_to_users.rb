class AddUniqueIndexesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index(:users, [:email, :confirmation_token], unique: true)
  end
end
