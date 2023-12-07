module PaymentMethods
  module Stripe
    class PaymentService < Base

      def create_payment_intent(stripe_customer_id, stripe_account_id, card_id, amount)
        amount_in_cents = (amount * 100).to_i # Amount should be in dollars
        ::Stripe::PaymentIntent.create(payment_intent_params(stripe_customer_id, stripe_account_id, card_id, amount_in_cents))
      end

      def confirm_payment_intent(payment_intent_id, card_id, redirect_url)
        ::Stripe::PaymentIntent.confirm(payment_intent_id, { payment_method: card_id, return_url: redirect_url }) # Disable 3D Secure for off-session payments
      end

      def cancel_payment_intent(payment_intent_id)
        ::Stripe::PaymentIntent.cancel(payment_intent_id, cancellation_reason: 'abandoned')
      end

      private

      def payment_intent_params(stripe_customer_id, stripe_account_id, card_id, amount_in_cents)
        {
          amount: amount_in_cents,
          currency: 'inr',
          automatic_payment_methods: {
            enabled: true,
            allow_redirects: 'never'
          },
          #application_fee_amount: calculate_application_fee(amount_in_cents),
          # transfer_data: {
          #   destination: stripe_account_id
          # },
          customer: stripe_customer_id,
          payment_method: card_id,
        }
      end



      def calculate_application_fee(amount_in_cents)
        (amount_in_cents * APPLICATION_FEE_PERCENTAGE) / 100
      end
    end
  end
end