module Payment
  module Strategies
    class PaypalStrategy < BaseStrategy
      def process_payment(amount)
        p "====================process_payment paypal"
        payment = PayPal::SDK::REST::Payment.new(payment_params)
        p payment
        if payment.create
          # redirect_to payment.links.find { |link| link.method == 'REDIRECT' }.href
        else
        end
        puts "Processing PayPal payment of #{amount} dollars"
      end

      private

      def payment_params
        {
          intent: 'sale',
          payer: {
            payment_method: 'paypal'
          },
          transactions: [
            {
              amount: {
                total: '10.00',
                currency: 'USD'
              }
            }
          ],
          redirect_urls: {
            return_url: "https://github.com/prabhkirat-s/payment_gateway_demo",
            cancel_url: "https://github.com/prabhkirat-s/payment_gateway_demo"
          }
        }
      end
    end
  end
end