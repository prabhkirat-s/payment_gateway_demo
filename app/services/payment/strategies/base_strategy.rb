module Payment
  module Strategies
    class BaseStrategy
      def process_payment(amount)
        raise NotImplementedError, 'Subclasses must implement this method'
      end
    end 
  end
end