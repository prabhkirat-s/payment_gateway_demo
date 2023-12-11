module Webhooks
	module PaymentMethods
		class StripesController < ::ApplicationController
			skip_before_action :verify_authenticity_token

			def create
				payload = request.body.read
			    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
			    webhook_secret = ENV['webhook_secret']

			    begin
			        @event = Stripe::Webhook.construct_event(
			            payload, sig_header, webhook_secret
			        )
			    rescue JSON::ParserError => e
			        # Invalid payload
			        return render_error(e)
			        
			    rescue Stripe::SignatureVerificationError => e
			        # Invalid signature
			        return render_error(e)
			    end

			    case @event.type
				when 'payment_intent.succeeded'
					create_payment_history('succeeded')
				when 'payment_intent.payment_failed'
					create_payment_history('failed')
				else
				  	return render_error(OpenStruct.new(message: "Event(#{@event.type}) not handled."))
				end

			    render json: { msg: 'Successfully Done' }, status: :ok
			end

			private

			def create_payment_history(status)
		        data = @event.data.object
		        PaymentHistory.create(application_fee: (data.application_fee_amount || 0), payment_intent_id: data.id, status: status, total_amount: data.amount, transfer_amount: data.amount_received, user_id: User.first.id)
	        end

			def render_error(error)
				render json: { msg: error.message }, status: 422
			end
		end
	end
end