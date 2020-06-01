desc 'Add auth token to users'
task clean_ip_activity: :environment do
  FeedActivity.where('created_at < ?', 1.day.ago).destroy_all
end
