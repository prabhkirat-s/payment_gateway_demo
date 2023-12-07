class ProductsController < ApplicationController

	before_action :set_stripe_customer_id, only: :show

	def index
		@products = Product.all
	end

	def show
		@product = Product.find(params[:id])
		response = PaymentMethods::Stripe::CardService.call(:card_list, @stripe_customer_id)
		if response[:error]
			flash[:error] = response[:error]
		else
			@cards = response[:data]
		end 

		@cards ||= []
	end

	private

	def set_stripe_customer_id
	    current_user.create_stripe_customer if current_user.stripe_customer_id.nil?
	    @stripe_customer_id = current_user.stripe_customer_id
	end
end
