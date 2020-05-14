class ChangeUserTypeInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :user_type, :integer, default: 0
  end
end
