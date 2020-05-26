class CreatePopularQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :popular_questions do |t|
      t.references :credit_transaction, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end
  end
end
