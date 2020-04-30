class CreditTransaction < ApplicationRecord
  belongs_to :user
  #FIXME_AB: enum status: { active: 0, archived: 1 }
  enum transaction_type: [:signup, :purchase, :debit]

  #FIXME_AB: after commit on create update user's credit balance
  #FIXME_AB: after save update self.credit balance
end
