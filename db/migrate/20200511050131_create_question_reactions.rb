class CreateQuestionReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :question_reactions do |t|
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :reaction_type
    end
  end
end
