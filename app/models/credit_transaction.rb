class CreditTransaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: {signup:0, purchase: 1, debit: 2}

  before_save :set_transaction_credit_balance
  after_commit :set_user_credit_balance

  private def set_transaction_credit_balance
    if self.signup?
      self.credit_balance = self.user.credit_balance + self.amount
    elsif self.debit?
      self.credit_balance = self.user.credit_balance - self.amount
    end
  end

  private def set_user_credit_balance
    #FIXME_AB:  user.refresh_credits!
    self.user.refresh_credits!
  end

end
