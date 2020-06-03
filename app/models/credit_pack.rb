class CreditPack < ApplicationRecord
  has_one_attached :image

    def create_credit_transaction(user)
      user.credit_transactions.create(amount: credits, transaction_type: CreditTransaction.transaction_types[:purchase], transactable: user)
    end
end
