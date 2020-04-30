class CreateCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.integer :transaction_type
      t.integer :credit_balance

      t.timestamps
    end
  end
end
