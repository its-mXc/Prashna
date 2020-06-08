# == Schema Information
#
# Table name: credit_packs
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  price      :integer
#  credits    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CreditPack < ApplicationRecord
  #FIXME_AB: add enabled disabled to credit packs only enabled packs will be display to user and only enabled packs can be purchased

  validates :name, presence: true
  validates :price, presence: true
  validates :credits, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 1}, if: -> {price.present?}
  validates :credits, numericality: {greater_than_or_equal_to: 1},if: -> {credits.present?}
  validate :cover_image_attached

  scope :enabled, -> { where(disabled: false) }
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
