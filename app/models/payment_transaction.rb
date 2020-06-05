class PaymentTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :credit_pack

  before_save :set_attributes

  private def set_attributes
    self.price = credit_pack.price
    self.credits = credit_pack.credits
    self.paid = response["paid"]
  end
end
