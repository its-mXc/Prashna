class AddMarkedAbuseToQuestionsAnswersComments < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :marked_abused, :boolean, default: false
    add_column :answers, :marked_abused, :boolean, default: false
    add_column :comments, :marked_abused, :boolean, default: false
  end
end
