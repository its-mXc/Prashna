class CreateQuestionTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :question_topics do |t|
      t.references :question, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
