class AddUrlSlugIndexToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_index :questions, :url_slug, unique: true
  end
end
