module Payment
  class ProcessorService
    def initialize(strategy_name)
      @payment_strategy = PaymentMethods::Strategy.payment_method(strategy_name)
                                                  .new
    end

    def process_payment(options)
      @payment_strategy.process_payment(options)
    end
  end
end