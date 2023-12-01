module Webhooks
	module PaymentMethods
		class StripesController < ::ApplicationController
			protect_from_forgery with: :null_session
			skip_before_action :verify_authenticity_token #to avoid csrf token error
			# before_action :set_default_response_format

			# respond_to :json #not working

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

			# def set_default_response_format
			#     request.format = :json if request.format.html?
		    # end

			def render_error(error)
				render json: { msg: error.message }, status: 422
			end
		end
	end
end