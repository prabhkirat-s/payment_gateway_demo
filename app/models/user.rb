class User < ApplicationRecord
	after_create_commit :create_stripe_customer

	def create_stripe_customer
		update_column(:stripe_customer_id, ::PaymentMethods::Stripe::CustomerService.call(:create_customer, self)[:id]) 
  	end
end
