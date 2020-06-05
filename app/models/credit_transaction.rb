# == Schema Information
#
# Table name: credit_transactions
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  amount            :integer
#  transaction_type  :integer
#  credit_balance    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  transactable_type :string(255)
#  transactable_id   :bigint
#
class CreditTransaction < ApplicationRecord
  enum transaction_type: { signup: 0, purchase: 1, debit: 2, popular: 3, reverted: 4 }

  belongs_to :user
  belongs_to :transactable, polymorphic: true

  before_save :set_transaction_credit_balance
  after_commit :set_user_credit_balance

  scope :reverse_chronological, -> {order(created_at: :desc)}

  private def set_transaction_credit_balance
    self.credit_balance = self.user.credit_balance + self.amount
  end

  private def set_user_credit_balance
    user.refresh_credits!
  end

  def reverse_transaction
    CreditTransaction.reverted.create(amount: (-1 * self.amount), user: user, transactable: self)
  end
end
