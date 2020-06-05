class AddReferencesToPaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :payment_transactions, :payment_transaction
    add_reference :payment_transactions, :credit_transaction
  end
end
