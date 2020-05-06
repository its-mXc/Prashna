class Topic < ApplicationRecord
  has_many :user_topics, dependent: :destroy
  has_many :users, through: :user_topics
  validates :name, presence: true, uniqueness: {case_sensitive: false}


  #FIXME_AB: make this a scope
  def self.search(term)
    where("name LIKE ?","%#{term}%")
  end
end
