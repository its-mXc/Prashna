class AddTransactableToCreditTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :credit_transactions, :transactable, polymorphic: true, index: { name: 'transactable_index' }
  end
end
