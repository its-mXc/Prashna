class AddReactionCountToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :reaction_count, :integer, default: 0
  end
end
