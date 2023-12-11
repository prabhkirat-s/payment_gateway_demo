class PaymentHistory < ApplicationRecord
  belongs_to :user

  enum status: { succeeded: 'succeeded', failed: 'failed', refunded: 'refunded' }


  def self.ransackable_attributes(auth_object = nil)
    ["application_fee", "created_at", "id", "id_value", "payment_intent_id", "status", "total_amount", "transfer_amount", "updated_at", "user_id"]
  end
end
