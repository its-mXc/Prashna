class CreateFeedActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :feed_activities do |t|
      t.string :ip
      t.string :url

      t.timestamps
    end
  end
end
