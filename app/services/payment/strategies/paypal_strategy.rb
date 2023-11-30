module Payment
  module Strategies
    class PayPalStrategy < BaseStrategy
      def process_payment(amount)
        # Implement PayPal payment processing logic
        puts "Processing PayPal payment of #{amount} dollars"
        # Add your PayPal API integration logic here
      end
    end
  end
end