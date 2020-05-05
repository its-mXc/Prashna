class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :user
      t.string :title
      t.text :content
      t.string :url_slug, unique_key: true

      t.timestamps
    end
  end
end
