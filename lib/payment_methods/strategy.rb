module PaymentMethods
  class Strategy
    STRATEGIES = {
      stripe: Strategies::Stripe,
      paypal: Strategies::Paypal,
    }.freeze

    def initialize(strategy)
      @strategy = strategy
    end

    def payment_method
      strategy = STRATEGIES[@strategy&.to_sym]
      raise Errors::InvalidSource, "Unavailable payment method: #{@strategy}" unless strategy

      strategy
    end

    def self.payment_method(strategy)
      new(strategy).payment_method
    end
  end
end

#PaymentMethods::Strategy.payment_method(params[:payment_method])