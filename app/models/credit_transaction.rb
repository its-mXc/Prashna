class CreditTransaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: [:signup, :purchase, :debit]
end
