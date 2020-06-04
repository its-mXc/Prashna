class CreatePaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :credit_pack, null: false, foreign_key: true
      t.string :status
      t.string :card_token
      t.json :response
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
