class Question < ApplicationRecord
  belongs_to :user

  validates :title, uniqueness: {case_sensitive: true}

  has_one_attached :file
end
