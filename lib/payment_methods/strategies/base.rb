module PaymentMethods
  module Strategies
    class Base
      def process_payment(amount)
        raise Errors::NotImplemented, "Subclasses must implement '#{__method__}' method"
      end
    end
  end
end
