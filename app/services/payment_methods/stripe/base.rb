module PaymentMethods
  module Stripe
    class Base

      APPLICATION_FEE_PERCENTAGE = ENV['APPLICATION_FEE_PERCENTAGE'].to_i || 10

      # attr_accessor :action_name

      # def initialize(action_name)
      #   unless respond_to? action_name
      #     raise ::Errors::NotImplemented, "Class(#{self.class.name}) must implement '#{@action_name}' method" 
      #   end

      #   @action_name = action_name
      # end

      def call(action_name, *arg)
        
        unless respond_to? action_name
          raise ::Errors::NotImplemented, "Class(#{self.class.name}) must implement '#{action_name}' method" 
        end

        send(action_name.to_sym, *arg)
      rescue Timeout::Error => e
        error_response(action_name, OpenStruct.new(message: 'Timeout error.'))
      rescue ::Stripe::CardError => e
        error_response(action_name, e)
      rescue ::Stripe::RateLimitError => e
        # Too many requests made to the API too quickly
        error_response(action_name, e)
      rescue ::Stripe::InvalidRequestError => e
        # Invalid parameters were supplied to Stripe's API
        error_response(action_name, e)
      rescue ::Stripe::AuthenticationError => e
        # Authentication with Stripe's API failed
        # (maybe you changed API keys recently)
        error_response(action_name, e)
      rescue ::Stripe::APIConnectionError => e
        # Network communication with Stripe failed
        error_response(action_name, e)
      rescue ::Stripe::StripeError => e
        # Display a very generic error to the user, and maybe send
        # yourself an email
        error_response(action_name, e)
      rescue => e
        # Something else happened, completely unrelated to Stripe
        error_response(action_name, e)
      end

      class << self
        def call(action_name, *arg)
          new.call(action_name, *arg)
        end
      end

      def error_response(action_name, error)
        Rails.logger.info "********************"
        Rails.logger.info "Error: #{error.class.name}"
        Rails.logger.info "#{action_name.to_s.titleize} - #{error}"
        Rails.logger.info "********************"
        { id: nil, error: error.message }
      end
    end
  end
end
