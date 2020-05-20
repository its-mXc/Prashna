class AddPolymorphicColumnsToNotification < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :notificable, polymorphic: true
    remove_reference :notifications, :question, foreign_key: true
  end
end