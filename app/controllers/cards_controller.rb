class CardsController < ApplicationController
  before_action :set_stripe_customer_id

  def new
  end

  def create
    create_card_token!
    create_card!

    flash[:success] = "Card added successfully!"
    redirect_to  CGI.parse(URI(request.referer).query)["return_url"]&.first || root_path
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to new_card_path
  end

  def destroy
    card_id = params[:id]
    response = PaymentMethods::Stripe::CardService.call(:delete_card, @stripe_customer_id, card_id)

    if response[:error]
      flash[:error] = response[:error]
    else
      flash[:success] = "Card deleted successfully"
    end
    redirect_back(fallback_location: root_path)
  end

  def make_default
    card_id = params[:id]
    response = StripeService.call(:make_default_card, @stripe_customer_id, card_id)
    return render json: { error: response[:error] }, status: :unprocessable_entity if response[:error].present?

    render json: { data: response.as_json, message: 'Set default successfully.', status: :ok }
  end

  private

  def set_stripe_customer_id
    current_user.create_stripe_customer if current_user.stripe_customer_id.nil?
    @stripe_customer_id = current_user.stripe_customer_id
  end

  def create_card_token!
    @card_token = PaymentMethods::Stripe::CardService.call(:create_card_token, params[:card_number], params[:exp_month], params[:exp_year], params[:cvc])
    raise @card_token[:error] if @card_token[:error]
  end

  def create_card!
    @card = PaymentMethods::Stripe::CardService.call(:create_card, @stripe_customer_id, @card_token[:id])
    raise @card[:error] if @card[:error]
  end
end
