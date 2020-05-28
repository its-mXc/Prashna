module Posted
  extend ActiveSupport::Concern

  def posted_by?(user)
    self.user == user
  end
end