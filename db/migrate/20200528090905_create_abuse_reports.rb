class CreateAbuseReports < ActiveRecord::Migration[6.0]
  def change
    create_table :abuse_reports do |t|
      t.references :abuseable, polymorphic: true
      t.references :user, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
