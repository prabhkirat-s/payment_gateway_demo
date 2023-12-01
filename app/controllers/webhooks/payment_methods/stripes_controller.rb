module Webhooks
	module PaymentMethods
		class StripesController < ::ApplicationController
			skip_before_action :verify_authenticity_token

			def create
				payload = request.body.read
			    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
			    webhook_secret = ENV['webhook_secret']
			    event = nil

			    begin
			        event = Stripe::Webhook.construct_event(
			            payload, sig_header, webhook_secret
			        )
			    rescue JSON::ParserError => e
			        # Invalid payload
			        return render_error(e)
			        
			    rescue Stripe::SignatureVerificationError => e
			        # Invalid signature
			        return render_error(e)
			    end

			    puts '************************************************'
			   	puts event.inspect
			   	puts '************************************************'

			    # Handle the event
			    puts "Unhandled event type: #{event.type}"

			    render json: { msg: 'Successfully Done' }, status: :ok
			end

			private

			def render_error(error)
				render json: { msg: error.message }, status: 422
			end
		end
	end
end