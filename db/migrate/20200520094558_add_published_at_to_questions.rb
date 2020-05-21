class AddPublishedAtToQuestions < ActiveRecord::Migration[6.0]
  def change
    #_AB: existing published  questions will give exceptions after this change. make a rake task to set publhished_at for all existing published questions
    add_column :questions, :published_at, :timestamp
  end
end
