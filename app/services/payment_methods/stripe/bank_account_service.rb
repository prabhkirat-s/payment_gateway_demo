module PaymentMethods
  module Stripe
    class BankAccountService < Base
      class << self
        def call(action_name, *arg)
          send(action_name.to_sym, *arg)
        rescue Timeout::Error => e
          error_response(action_name, OpenStruct.new(message: 'Timeout error.'))
        rescue StandardError => e
          error_response(action_name, e)
        end

        def create_bank_account(stripe_account_id, params)
          bank_token = Stripe::Token.create(bank_token_params(params))
          Stripe::Account.create_external_account(stripe_account_id, { external_account: bank_token.id })
        end

        def make_default_bank_account(stripe_account_id, bank_account_id)
          Stripe::Account.update_external_account(stripe_account_id, bank_account_id, { default_for_currency: true })
        end

        def delete_bank_account(stripe_account_id, bank_account_id)
          Stripe::Account.delete_external_account(stripe_account_id, bank_account_id)
        end

        def bank_account_list(stripe_account_id, limit = 10)
          Stripe::Account.list_external_accounts(stripe_account_id, { object: 'bank_account', limit: limit })
        end


        private

        def bank_token_params(params)
          {
            bank_account: {
              country: 'US',
              currency: 'usd',
              account_holder_name: params[:account_holder_name],
              account_holder_type: 'individual',
              routing_number: params[:routing_number],
              account_number: params[:account_number]
            }
          }
        end

        def error_response(action_name, error)
          Rails.logger.info "********************"
          Rails.logger.info "#{action_name.to_s.titleize} - #{error}"
          Rails.logger.info "********************"
          { id: nil, error: error.message }
        end
      end
    end
  end
end