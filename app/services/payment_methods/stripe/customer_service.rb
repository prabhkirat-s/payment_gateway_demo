module PaymentMethods
  module Stripe
    class CustomerService < Base

      def create_customer(user)
        ::Stripe::Customer.create({ name: user.full_name, email: user.email })
      end

      # def get_customer(strip_customer_id)
      #   ::Stripe::Customer.retrieve(strip_customer_id)
      # end
    end
  end
end