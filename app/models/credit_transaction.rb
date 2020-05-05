class CreditTransaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: {signup:0, purchase: 1, debit: 2}

  before_save :set_transaction_credit_balance
  after_commit :set_user_credit_balance

  private def set_transaction_credit_balance
    if self.signup?
      self.credit_balance = self.credit_balance.to_i + self.amount
    end
  end

  private def set_user_credit_balance
    self.user.credit_balance = self.credit_balance
    self.user.save
  end

end
