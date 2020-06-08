# == Schema Information
#
# Table name: payment_transactions
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  credit_pack_id :bigint           not null
#  status         :string(255)
#  card_token     :string(255)
#  response       :json
#  paid           :boolean          default(FALSE)
#  price          :integer
#  credits        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class PaymentTransaction < ApplicationRecord

  enum status: { pending: 0, failed: 1, paid: 2, refunded: 3 }
  #FIXME_AB: status: pending, paid, refunded, failed
  #FIXME_AB: add column paid_at, refunded_at
  #FIXME_AB: transaction_id column which will save charge id

  #FIXME_AB: add method refund! which will refund the transaction amount if paid. and set refunded_at and refund state. Also send email to user
  extend ActiveModel::Callbacks

  define_model_callbacks :mark_paid, only: :after
  define_model_callbacks :mark_refunded, only: :after

  belongs_to :user
  belongs_to :credit_pack
  belongs_to :credit_transaction, optional: true
  belongs_to :payment_transaction, optional: true

  before_save :set_attributes
  after_mark_paid :create_credit_transaction
  after_mark_paid :send_purchase_successfull_email
  after_mark_refunded :revert_credit_transaction
  after_mark_refunded :send_refund_successfull_email

  private def set_attributes
    self.price = credit_pack.price
    self.credits = credit_pack.credits
    unless response.nil?
      self.paid = response["paid"] 
      self.transaction_id = response["id"]
    end
  end

  def mark_paid!
    run_callbacks :mark_paid do
      self.status = PaymentTransaction.statuses["paid"]
      self.paid_at = Time.current
      save!
    end
  end
  
  def mark_failed(message)
    self.status = PaymentTransaction.statuses["failed"]
    self.message = message
    save!
  end
  
  def refund(message)
    if self.paid?
      run_callbacks :mark_refunded do
        refund = Stripe::Refund.create(charge: transaction_id)
        @payment_transaction = PaymentTransaction.refunded.create(user: user, credit_pack: credit_pack, response: refund, refunded_at: Time.current,payment_transaction: self, message: message)
      end
    end
  end
  
  def refundable?
    self.paid? && PaymentTransaction.find_by(payment_transaction_id: id).nil?
  end
  
  private def create_credit_transaction
    self.credit_transaction = credit_pack.create_credit_transaction(user)
    save
  end
  
  private def revert_credit_transaction
    reverted_credit_transaction = credit_transaction.reverse_transaction
    @payment_transaction.update(credit_transaction: reverted_credit_transaction)
  end

  private def send_purchase_successfull_email
    PaymentTransactionMailer.send_purchase_email(self).deliver_later
  end
  
  private def send_refund_successfull_email
    PaymentTransactionMailer.send_refund_email(@payment_transaction).deliver_later
  end
end
