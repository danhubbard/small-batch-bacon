class CheckoutsController < ApplicationController
  def show
    cookies.delete :basket
  end

  def create
    basket = JSON.parse(cookies[:basket] ||= "{}")
    redirect_to basket_path and return if basket.empty?

    session = Checkout.create_stripe_session(basket)
    redirect_to session.url, allow_other_host: true
  end
end
