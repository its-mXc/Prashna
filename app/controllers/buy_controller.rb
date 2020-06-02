class BuyController < ApplicationController
  before_action :ensure_logged_in
  
  def index
  end

  def subscribe
    if current_user.stripe_id.nil?
      redirect_to billing_index_path, notice: 'Firstly you need to enter your card'
    end
    #if there is no card

    customer = Stripe::Customer.new current_user.stripe_id
    #we define our customer

    subscriptions = Stripe::Subscription.list(customer: customer.id)
    subscriptions.each do |subscription|
      subscription.delete
    end
    #we delete all subscription that the customer has. We do this because we don't want that our customer to have multiple subscriptions

    plan_id = params[:plan_id]
    subscription = Stripe::Subscription.create({ customer: customer,
                                                   items: [{plan: plan_id}], })
 #we are creating a new subscription with the plan_id we took from our form
    if plan_id == ENV["10_dollar_pack_id"]
      current_user.credit_transactions.create(amount: ENV["10_dollar_pack_credits"].to_i, transaction_type: CreditTransaction.transaction_types["purchase"], transactable: current_user)
    elsif plan_id == ENV["15_dollar_pack_id"]
      current_user.credit_transactions.create(amount: ENV["15_dollar_pack_credits"].to_i, transaction_type: CreditTransaction.transaction_types["purchase"], transactable: current_user)
    end

    subscription.save
    redirect_to my_profile_path, notice: "Credits purchased"
  end

end