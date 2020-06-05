class CreateCreditPacks < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_packs do |t|
      t.string :name
      t.integer :price
      t.integer :credits

      t.timestamps
    end
  end
end
