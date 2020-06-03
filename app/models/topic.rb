# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Topic < ApplicationRecord
  has_many :user_topics, dependent: :destroy
  has_many :users, through: :user_topics
  has_many :question_topics
  has_many :questions, through: :question_topics
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  scope :search, ->(term) { where("name LIKE ?","%#{term}%") }


end
