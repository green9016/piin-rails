# frozen_string_literal: true

require 'stripe'
class StripeService # :nodoc:
  attr_reader :params
  def initialize(params, user, pin = nil)
    @token = nil
    @params = params
    @user = user
    @pin = pin
  end

  def create_token
    @token = Stripe::Token.create(
      card: {
        number: params[:card_number],
        exp_month: params[:exp_month],
        exp_year: params[:exp_year],
        cvc: params[:cvc]
      }
    )
  end

  def create_customer
    customer = Stripe::Customer.create(source: @token)
    @user.update(stripe_customer_id: customer.id)
    customer
  end

  def make_payment
    customer = stripe_customer
    charge = create_charge(customer)
    @user.purchases.create(pin_id: @pin.id, total: charge.amount,
                           stripe_id: charge.id, status: charge.status,
                           company_name: @pin.firm.name, date: Date.today,
                           email: @user.email)
  rescue Stripe::CardError, Stripe::InvalidRequestError,
         Stripe::AuthenticationError => e
    { error: e.message }
  end

  def create_subscription
    customer = stripe_customer
    plan = Stripe::Plan.retrieve(params[:plan_id])
    if plan.active == true && customer.present?
      Stripe::Subscription.create(customer: customer.id,
                                  items: [{ plan: plan }])
    end
  rescue Stripe::CardError, Stripe::InvalidRequestError,
         Stripe::AuthenticationError => e
    { error: e.message }
  end

  def stripe_customer
    customer = retrieve_customer

    return customer if customer.present?

    create_token
    create_customer
  end

  def create_charge(customer)
    Stripe::Charge.create(customer: customer.id,
                          amount: params[:charges],
                          currency: 'usd')
  end

  def save_card
    Stripe::Customer.create_source(stripe_customer.id, source: create_token)
  rescue Stripe::CardError, Stripe::InvalidRequestError,
         Stripe::AuthenticationError => e
    { error: e.message }
  end

  private

  def retrieve_customer
    Stripe::Customer.retrieve(@user.stripe_customer_id)
  rescue Stripe::StripeError
    nil
  end
end
