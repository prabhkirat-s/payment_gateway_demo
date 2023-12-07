class PaymentsController < ApplicationController
  before_action :find_product
  
  # def create
  #   @processor = Payment::ProcessorService.new(params[:payment_strategy])
  #   response = @processor.process_payment(payment_options)

  #   raise "Something went wrong" unless response[:redirect_url]

  #   redirect_to response[:redirect_url], layout: false, allow_other_host: true
  # rescue StandardError => e
  #   flash[:error] = e.message
  #   redirect_to product_path(@product)
  # end

  def success
    flash[:success] = "Payment done successfully!"
    redirect_to products_path
  end

  def cancel
    flash[:error] = "Payment failed!"
    redirect_to products_path
  end


  def create
    payment_response = PaymentMethods::Stripe::PaymentService.call(:create_payment_intent, current_user.stripe_customer_id, @stripe_account_id, params[:card_id], @product.price)
    raise payment_response[:error] if payment_response[:error]
    
    confirm_payment_response = PaymentMethods::Stripe::PaymentService.call(:confirm_payment_intent, payment_response[:id], params[:card_id], redirect_url_after_payment)
    raise confirm_payment_response[:error] if confirm_payment_response[:error]
    
    puts "#{confirm_payment_response.inspect}"

    flash[:success] = "Payment done successfully!"
    redirect_to confirm_payment_response[:next_action][:redirect_to_url][:url], layout: false, allow_other_host: true
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to product_path(@product)
  end



  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def payment_options
    { 
      product: @product, 
      success_url: success_product_payment_url(@product),
      cancel_url: cancel_product_payment_url(@product)
    }
  end

  def redirect_url_after_payment
    success_product_payment_url(@product)
  end
end