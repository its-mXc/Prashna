class CreditTransaction < ApplicationRecord
  enum transaction_type: { signup: 0, purchase: 1, debit: 2, popular: 3, revert: 4 }

  belongs_to :user
  belongs_to :transactable, polymorphic: true

  before_save :set_transaction_credit_balance
  after_commit :set_user_credit_balance

  private def set_transaction_credit_balance
    self.credit_balance = self.user.credit_balance + self.amount
  end

  private def set_user_credit_balance
    user.refresh_credits!
  end

  def reverse_transaction
    CreditTransaction.create(amount: -self.amount, transaction_type: CreditTransaction.transaction_types["revert"], user: user, transactable: self)
  end
end
