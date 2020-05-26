class PopularQuestion < ApplicationRecord
  belongs_to :answer
  belongs_to :credit_transaction

  after_commit :revert_transaction, on: :destroy

  private def revert_transaction
    puts "hello"
    credit_transaction.revert
    # transaction.user.refresh_credits!
    puts "bye"
  end
end
