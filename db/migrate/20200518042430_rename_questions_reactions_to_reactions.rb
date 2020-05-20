class RenameQuestionsReactionsToReactions < ActiveRecord::Migration[6.0]
  def change
    rename_table :question_reactions, :reactions
  end
end
