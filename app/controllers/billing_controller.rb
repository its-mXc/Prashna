class BillingController < ApplicationController
  before_action :ensure_logged_in

  def index
  end

  def new_card
    respond_to do |format|
      format.js
    end
  end

  def create_card 
    if current_user.stripe_id.nil?
      customer = Stripe::Customer.create({"email": current_user.email}) 
      #here we are creating a stripe customer with the help of the Stripe library and pass as parameter email. 
      current_user.update(:stripe_id => customer.id)
      #we are updating current_user and giving to it stripe_id which is equal to id of customer on Stripe
    end

    card_token = params[:stripeToken]
    #it's the stripeToken that we added in the hidden input
    if card_token.nil?
      redirect_to billing_index_path, notice: "Error, no card token"
    end
    #checking if a card was giving.

    customer = Stripe::Customer.new current_user.stripe_id
    customer.source = card_token
    #we're attaching the card to the stripe customer
    customer.save

    redirect_to my_profile_path, notice: "Card Added"
  end
  
end