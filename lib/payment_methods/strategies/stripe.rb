module PaymentMethods
  module Strategies
    class Stripe < Base
      def process_payment(options)
        @product = options[:product]
        session = ::Stripe::Checkout::Session.create({
          line_items: [{
            price: create_price&.id,
            quantity: 1,
          }],
          mode: 'payment',
          success_url: options[:success_url],
          cancel_url: options[:cancel_url],
        })

        { redirect_url: session.url }
      end

      private

      def create_price
        ::Stripe::Price.create({currency: 'usd', unit_amount: amount_in_cents, product_data: { name: @product.name },})
      end

      def amount_in_cents
        (@product.price * 100).to_i
      end
    end
  end
end

# Stripe::Customer.create({ name: 'Jenny Rosen', email: 'jennyrosen@example.com', })
# ::Stripe::Token.create({ card: { number: '4242424242424242', exp_month: '5', exp_year: '2024', cvc: '314', }, })
