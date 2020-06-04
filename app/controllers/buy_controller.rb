class BuyController < ApplicationController
  before_action :ensure_logged_in
  before_action :set_credit_pack, only: [:payment, :charge]
  before_action :ensure_stripe_token_exist, only: :charge

  def index
    @packs = CreditPack.all
  end

  def payment
  end
  
  #FIXME_AB: make payment transaction model also
  
  def charge
    begin
      logger.tagged('Stripe Credit Pack Buy') {
          if current_user.stripe_id.nil?
            logger.info "Creating stripe customer for user #{user}"
            customer = Stripe::Customer.create({"email": current_user.email}) 
            logger.info customer
            current_user.update(stripe_id: customer.id)
        end
        
        card_token = params[:stripeToken]
        logger.info "Creating charge for #{@credit_pack} against card #{card_token}"
        charge = Stripe::Charge.create({
          amount: @credit_pack.price*100,
          currency: 'inr',
          source: card_token,
          description: @credit_pack.name,
          customer: customer
        })
        logger.info charge
        current_user.payment_transactions.create(credit_pack: @credit_pack, card_token: card_token, response: charge)
        if charge.paid
          @credit_pack.create_credit_transaction(current_user)
          redirect_to my_profile_path, notice: "Purchase successful"
          else
            redirect_to my_profile_path, notice: "Purchase unsuccessful"
        end
        }
    rescue Stripe::CardError
      redirect_to buy_index_path, notice: "Card Declined"
    end   
  end
  
  private def set_credit_pack
    @credit_pack = CreditPack.find_by(id: params[:pack_id])
  end

  private def ensure_stripe_token_exist
    if params[:stripeToken].nil?
      redirect_to buy_index_path, notice: "Error: No Stripe Token"
    end
  end

end
