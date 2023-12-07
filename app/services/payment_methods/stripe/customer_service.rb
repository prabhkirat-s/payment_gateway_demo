module PaymentMethods
  module Stripe
    class CustomerService < Base

      # def call(action_name, *arg)
      #   send(action_name.to_sym, *arg)
      # rescue Timeout::Error => e
      #   error_response(action_name, OpenStruct.new(message: 'Timeout error.'))
      # rescue Stripe::InvalidRequestError => e
      #   error_response(action_name, e)
      # rescue StandardError => e
      #   error_response(action_name, e)
      # end

      def create_customer(user)
        Stripe::Customer.create({ name: user.full_name, email: user.email })
      end

      def get_customer(strip_customer_id)
        Stripe::Customer.retrieve(strip_customer_id)
      end
    end
  end
end



PaymentMethods::Stripe::CustomerService