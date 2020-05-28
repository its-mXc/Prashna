class AddPublishedAtToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :published_at, :timestamp
  end
end
