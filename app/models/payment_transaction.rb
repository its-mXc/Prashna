class PaymentTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :credit_pack

  before_save :set_paid_status

  private def set_paid_status
    self.paid = response["paid"]
  end
end
