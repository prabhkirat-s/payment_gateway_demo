class PaymentsController < ApplicationController
  before_action :find_product
  
  def create
    @processor = Payment::ProcessorService.new(params[:payment_strategy])
    response = @processor.process_payment(payment_options)

    raise "Something went wrong" unless response[:redirect_url]

    redirect_to response[:redirect_url], layout: false, allow_other_host: true
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to product_path(@product)
  end

  def success
    flash[:success] = "Payment done successfully!"
    redirect_to products_path
  end

  def cancel
    flash[:error] = "Payment failed!"
    redirect_to products_path
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
end