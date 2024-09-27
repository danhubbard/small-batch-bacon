class CheckoutsController < ApplicationController
  def create
    basket = JSON.parse(cookies[:basket] ||= "{}")
    
    if basket.empty?
      Rails.logger.info("Basket is empty")
      redirect_to basket_path, alert: "Your basket is empty."
      return
    end

    Rails.logger.info("Creating Stripe session...")

    session = Checkout.create_stripe_session(basket)
    if session
      Rails.logger.info("Session created: #{session.id}")
      redirect_to session.url, allow_other_host: true
    else
      Rails.logger.error("Failed to create Stripe session")
      redirect_to basket_path, alert: "An error occurred while processing your payment. Please try again."
    end
  rescue => e
    Rails.logger.error("Error in checkout process: #{e.message}")
    redirect_to basket_path, alert: "An unexpected error occurred. Please try again later."
  end
end