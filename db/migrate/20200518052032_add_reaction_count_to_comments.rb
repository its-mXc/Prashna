class AddReactionCountToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :reaction_count, :integer, default: 0
  end
end
