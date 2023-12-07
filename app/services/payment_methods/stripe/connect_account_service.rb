module PaymentMethods
  module Stripe
    class ConnectAccountService < Base
      class << self
        def call(action_name, *arg)
          send(action_name.to_sym, *arg)
        rescue Timeout::Error => e
          error_response(action_name, OpenStruct.new(message: 'Timeout error.'))
        rescue StandardError => e
          error_response(action_name, e)
        end

        def create_account(counselor_profile, request_ip)
          profile = counselor_profile
          Stripe::Account.create(account_params(profile, request_ip))
        end

        def get_account(stripe_account_id)
          Stripe::Account.retrieve(stripe_account_id)
        end

        # Create connect account link to update required info on stripe for couselor connect account setup
        def create_account_link(stripe_account_id)
          Stripe::AccountLink.create(account_link_params(stripe_account_id))
        end

        private

        def account_params(profile, request_ip)
          user = profile.user
          {
            type: 'custom',
            country: 'US',
            email: user.email,
            capabilities: {
              card_payments: {
                requested: true
              },
              transfers: {
                requested: true
              }
            },
            tos_acceptance: {
              date: Time.now.to_i,
              ip: request_ip
            },
            business_type: 'individual',
            business_profile: {
              mcc: 7277,
              name: profile.fullname
            },
            individual: {
              email: user.email,
              first_name: profile.first_name,
              last_name: profile.last_name
            }
          }
        end

        def account_link_params(stripe_account_id)
          {
            account: stripe_account_id,
            refresh_url: 'https://example.com/reauth',
            return_url: 'https://example.com/return',
            type: 'account_update' # Possible values - account_onboarding, account_update
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