class CreditPack < ApplicationRecord

  validates :name, presence: true
  validates :price, presence: true
  validates :credits, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 1}, if: -> {price.present?}
  validates :credits, numericality: {greater_than_or_equal_to: 1},if: -> {credits.present?}
  validate :cover_image_attached
  
  has_one_attached :cover_image

  def create_credit_transaction(user)
    user.credit_transactions.create(amount: credits, transaction_type: CreditTransaction.transaction_types[:purchase], transactable: user)
  end

  private def cover_image_attached
    unless self.cover_image.attached? 
      errors.add(:base, "Cover image should be present")
    end
  end
  
end
