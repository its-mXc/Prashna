class AddDisabledToCreditPacks < ActiveRecord::Migration[6.0]
  def change
    add_column :credit_packs, :disabled, :boolean, default: false
  end
end
