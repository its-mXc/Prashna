# == Schema Information
#
# Table name: feed_activities
#
#  id         :bigint           not null, primary key
#  ip         :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FeedActivity < ApplicationRecord
  scope :by_ip, ->(ip) { where(ip: ip) }
  scope :by_url, ->(url) { where(url: url) }
  scope :in_past, ->(time) { where("created_at >= ? ", time.ago) }

end
