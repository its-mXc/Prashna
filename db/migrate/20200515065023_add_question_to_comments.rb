class AddQuestionToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :question, null: false, foreign_key: true
  end
end
