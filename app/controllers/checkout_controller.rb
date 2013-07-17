# -*- encoding : utf-8 -*-
class CheckoutController < ApplicationController

  include ActiveMerchant::Billing
  include CheckoutHelper

  layout "application"

  before_filter :assigns_gateway

  def finish
    address = nil
    @transaction = Transaction.create_transaction(current_user, session[:carrinho])
    # @order = Order.create_order(@transaction)
    total_as_cents, setup_purchase_params = get_setup_purchase_params Order.new(total: @transaction.total), request, @transaction.items
    puts total_as_cents.inspect
    puts '-' * 100
    puts setup_purchase_params.inspect
    setup_response = @gateway.setup_purchase(total_as_cents, setup_purchase_params)
    puts '-' * 100
    puts setup_response.params
    redirect_to @gateway.redirect_url_for(setup_response.token)
  end

  def review
    if params[:token].nil? or params[:PayerID].nil?
      redirect_to checkout_path(:experience_date_id => session[:experience_date_id]), :notice => "Sorry! Something went wrong with the Paypal purchase. Please try again later."
      return
    end
    @experience_date = ExperienceDate.find(session[:experience_date_id])
    @experience = @experience_date.experience
    @transaction = Transaction.where(:user_id => current_user.id).last
    total_as_cents, purchase_params = get_purchase_params @experience, request, @transaction.items, params
    @purchase = @gateway.purchase total_as_cents, purchase_params
    @transaction = Transaction.update_transaction(request, @purchase, @experience_date, current_user)

    if @purchase.success?
      @notice = "Thanks! Your purchase is now complete!"
    else
      @notice = "Woops. Something went wrong while we were trying to complete the purchase with Paypal. Btw, here's what Paypal said: #{@purchase.message}"
    end
  end

  def assigns_gateway
    hash = {
      :login => APP_CONFIG["paypal_login"],
      :password => APP_CONFIG["paypal_password"],
      :signature => APP_CONFIG["paypal_api_signature"]
    }
    @gateway ||= PaypalExpressGateway.new(
      :login => hash[:login],
      :password => hash[:password],
      :signature => hash[:signature]
    )
  end


end
