class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, :set_stripe_customer_id
  before_action :validate_card_token, only: :create

  def index
    # @service = PaymentMethods::Stripe::CardService.new(:action_name)
    # response = @service.call(param1, param2)
    response = PaymentMethods::Stripe::CardService.call(:card_list, @stripe_customer_id)
    redirect_to product_path if response[:error].present?

    default_card = StripeService.call(:get_customer, @stripe_customer_id)&.default_source
    render json: { data: response.data.as_json, default_card: default_card, status: :ok }
  end

  def create
    response = StripeService.call(:create_card, @stripe_customer_id, params[:card_token])
    return render json: { error: response[:error] }, status: :unprocessable_entity if response[:error].present?

    render json: { data: response.as_json, status: :ok }
  end

  def destroy
    card_id = params[:id]
    response = StripeService.call(:delete_card, @stripe_customer_id, card_id)
    return render json: { error: response[:error] }, status: :unprocessable_entity if response[:error].present?

    render json: { data: response.as_json, message: 'Card deleted successfully.', status: :ok }
  end

  def make_default
    card_id = params[:id]
    response = StripeService.call(:make_default_card, @stripe_customer_id, card_id)
    return render json: { error: response[:error] }, status: :unprocessable_entity if response[:error].present?

    render json: { data: response.as_json, message: 'Set default successfully.', status: :ok }
  end

  private

  def validate_card_token
    return if params[:card_token].present?

    render json: { error: "Missing card_token." } and return
  end

  def set_stripe_customer_id
    user.create_stripe_customer if current_user.stripe_customer_id.nil?
    @stripe_customer_id = current_user.stripe_customer_id
  end
end
