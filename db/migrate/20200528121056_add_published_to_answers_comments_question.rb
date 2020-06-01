class AddPublishedToAnswersCommentsQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :published, :boolean, default: true
    add_column :comments, :published, :boolean, default: true
  end
end
