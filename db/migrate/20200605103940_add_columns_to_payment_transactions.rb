class ChangeStatusToBeIntegerInPaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    change_column :payment_transactions, :status, :integer
    add_column :payment_transactions, :paid_at, :datetime
    add_column :payment_transactions, :refunded_at, :datetime
    add_column :payment_transactions, :transaction_id, :string
  end
end
