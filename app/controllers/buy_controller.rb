class BuyController < ApplicationController
  before_action :ensure_logged_in

  def index
  end

  #FIXME_AB: make payment transaction model also

  def subscribe
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    #if there is no card
    if current_user.stripe_id.nil?
      redirect_to billing_index_path, notice: "Please add card"
    else
      customer = Stripe::Customer.new current_user.stripe_id
      logger.tagged('Stripe subscription customer ') { logger.info customer }
      #we define our customer

      subscriptions = Stripe::Subscription.list(customer: customer.id)
      subscriptions.each do |subscription|
        subscription.delete
      end
      logger.tagged('Stripe previous subscription delete ') { logger.info subscriptions }

      #we delete all subscription that the customer has. We do this because we don't want that our customer to have multiple subscriptions

      plan_id = params[:plan_id]
      subscription = Stripe::Subscription.create({ customer: customer, items: [{plan: plan_id}], })

      logger.tagged('Stripe new subscription create ') { logger.info subscription }

      #we are creating a new subscription with the plan_id we took from our form
      if plan_id == ENV["10_dollar_pack_id"]
        current_user.credit_transactions.create(amount: ENV["10_dollar_pack_credits"].to_i, transaction_type: CreditTransaction.transaction_types["purchase"], transactable: current_user)
      elsif plan_id == ENV["15_dollar_pack_id"]
        current_user.credit_transactions.create(amount: ENV["15_dollar_pack_credits"].to_i, transaction_type: CreditTransaction.transaction_types["purchase"], transactable: current_user)
      end

      subscription.save
      logger.tagged('Stripe new subscription save ') { logger.info subscription }
      redirect_to my_profile_path, notice: "Credits purchased"
    end

  end

end
