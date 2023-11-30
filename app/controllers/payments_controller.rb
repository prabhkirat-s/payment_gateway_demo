class PaymentsController < ApplicationController
  before_action :find_product
  def create
    find_payment_strategy
    amount = @product.price.to_f
    @processor = Payment::ProcessorService.new(@strategy)
    result = @processor.process_payment(amount)

    # Handle the result
    if result.successful?
      flash[:success] = "Payment succeeded!"
    else
      flash[:error] = result.error_message
    end
    redirect_to product_path(@product)
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to product_path(@product)
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_payment_strategy
    case params[:payment_strategy]
    when 'paypal'
      @strategy = Payment::Strategies::PaypalStrategy.new
    when 'stripe'
      @strategy = Payment::Strategies::StripeStrategy.new
    else
      raise 'Invalid payment strategy'
    end
  end

  def payment_params
    params.permit(:payment_strategy, :card_number, :expiry_date, :cvc)
  end
end