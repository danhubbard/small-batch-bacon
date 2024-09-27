class BasketsController < ApplicationController
  def show 
    @basket = JSON.parse(cookies[:basket] ||= "{}")
  end

  def create
    basket = cookies[:basket] ? JSON.parse(cookies[:basket]) : {}
    
    new_item = {
      weight: params[:weight],
      cut: params[:cut],
      cure: params[:cure],
      smoke: params[:smoke],
      sliced: params[:sliced]
    }

    # Generate a unique key for the new item
    item_key = "item_#{Time.now.to_i}"
    basket[item_key] = new_item

    cookies[:basket] = JSON.generate(basket)

    Rails.logger.info("Basket: #{cookies[:basket]}")

    redirect_to products_path, notice: 'Item added to basket successfully!'
  end
end
