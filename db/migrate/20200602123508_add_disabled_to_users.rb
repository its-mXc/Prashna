class AddDisabledToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :disabled, :boolean, default: false
  end
end
