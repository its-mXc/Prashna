class RemoveFollowersCountFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :followers_count
  end
end
