module PaymentMethods
  module Strategies
    class Paypal < Base
      def process_payment(options)
        @product = options[:product]
        payment = ::PayPal::SDK::REST::Payment.new(payment_params(options))
        payment.create

        redirect_url = payment.links.find { |link| link.method == 'REDIRECT' }.href
        { redirect_url: redirect_url }
      end

      private

      def payment_params(options)
        {
          intent: 'sale',
          payer: {
            payment_method: 'paypal'
          },
          transactions: [
            {
              amount: {
                total: @product.price,
                currency: 'USD'
              }
            }
          ],
          redirect_urls: {
            return_url: options[:success_url],
            cancel_url: options[:cancel_url]
          }
        }
      end
    end
  end
end
