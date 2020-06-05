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

  #FIXME_AB: status: pending, paid, refunded, failed
  #FIXME_AB: add column paid_at, refunded_at
  #FIXME_AB: transaction_id column which will save charge id

  #FIXME_AB: add method refund! which will refund the transaction amount if paid. and set refunded_at and refund state. Also send email to user

  belongs_to :user
  belongs_to :credit_pack

  before_save :set_attributes

  private def set_attributes
    self.price = credit_pack.price
    self.credits = credit_pack.credits
    self.paid = response["paid"]
  end
end
