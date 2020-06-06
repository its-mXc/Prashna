class PaymentTransactionMailer < ApplicationMailer
  def send_purchase_email(payment_transaction)
    @payment_transaction = payment_transaction
    mail to: @payment_transaction.user.email, subject: 'Credit Pack Successful'
  end
  
  def send_refund_email(payment_transaction)
    @payment_transaction = payment_transaction
    mail to: @payment_transaction.user.email, subject: 'Refund Successfull'
  end
end