class AddMessageToPaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_transactions, :message, :string
  end
end
