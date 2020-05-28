class AddPopularityCreditsGrantedToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :popularity_credits_granted, :boolean, default: false
  end
end
