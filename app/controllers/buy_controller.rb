class BuyController < ApplicationController
  before_action :ensure_logged_in
  before_action :set_credit_pack, only: [:charge, :subscribe]

  def index
    @packs = CreditPack.all
  end

  def charge
    # @credit_pack = CreditPack.find_by(id: params[:pack_id])
    # request.format = :js
  end
  
  #FIXME_AB: make payment transaction model also
  
  def subscribe
    if current_user.stripe_id.nil?
      customer = Stripe::Customer.create({"email": current_user.email}) 
      current_user.update(stripe_id: customer.id)
    end
    
    card_token = params[:stripeToken]
    charge = Stripe::Charge.create({
      amount: @credit_pack.price*100,
      currency: 'inr',
      source: card_token,
      description: @credit_pack.name,
      customer: customer
    })
    if charge.paid
      @credit_pack.create_credit_transaction(current_user)
    end
  end
  
  private def set_credit_pack
    @credit_pack = CreditPack.find_by(id: params[:pack_id])
  end

end
