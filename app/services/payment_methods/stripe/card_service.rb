module PaymentMethods
  module Stripe
    class CardService < Base
      def create_card(strip_customer_id, card_token)
        ::Stripe::Customer.create_source(strip_customer_id, { source: card_token })
      end

      def delete_card(strip_customer_id, card_id)
        ::Stripe::Customer.delete_source(strip_customer_id, card_id)
      end

      def card_list(strip_customer_id, limit = 10)
        ::Stripe::Customer.list_sources(strip_customer_id, { object: 'card', limit: limit })
      end

      # def get_card(strip_customer_id, card_id)
      #   ::Stripe::Customer.retrieve_source(strip_customer_id, card_id)
      # end

      # def make_default_card(strip_customer_id, card_id)
      #   ::Stripe::Customer.update(strip_customer_id, { default_source: card_id })
      # end

      def create_card_token(card_number, exp_month, exp_year, cvc)
        ::Stripe::Token.create({ card: { number: card_number, exp_month: exp_month, exp_year: exp_year, cvc: cvc }, })
      end
    end
  end
end