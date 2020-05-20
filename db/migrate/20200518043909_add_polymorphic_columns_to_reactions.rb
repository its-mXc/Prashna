class AddPolymorphicColumnsToReactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :reactions, :reactable, polymorphic: true
    remove_reference :reactions, :question, foreign_key: true
  end
end
