class BasketsController < ApplicationController
  before_action :set_basket, only: [:show, :destroy]

  def show 
    @basket = JSON.parse(cookies[:basket] ||= "{}")
  end

  def create
    basket = cookies[:basket] ? JSON.parse(cookies[:basket]) : {}
    
    new_item = {
      product_name: params[:name],
      weight: params[:weight],
      cure: params[:cure],
      smoke: params[:smoke],
      sliced: params[:sliced],
      price: params[:price].to_i
    }

    # Generate a unique key for the new item
    item_key = "item_#{Time.now.to_i}"
    basket[item_key] = new_item

    cookies[:basket] = JSON.generate(basket)

    Rails.logger.info("Basket: #{cookies[:basket]}")

    redirect_to basket_path, notice: 'Item added to basket successfully!'
  end

  def destroy
    basket = JSON.parse(cookies[:basket] ||= "{}")
    item_key = params[:id]
    
    if basket.key?(item_key)
      basket.delete(item_key)
      cookies[:basket] = JSON.generate(basket)
      
      @basket = basket
      @basket_total = calculate_basket_total(@basket)
      
      if @basket.empty?
        render turbo_stream: [
          turbo_stream.remove("basket_item_#{item_key}"),
          turbo_stream.replace("basket_content", partial: "baskets/empty_basket"),
          turbo_stream.replace("basket_total", partial: "baskets/total", locals: { basket: @basket, basket_total: @basket_total }),
          turbo_stream.remove("basket_actions")
        ]
      else
        render turbo_stream: [
          turbo_stream.remove("basket_item_#{item_key}"),
          turbo_stream.replace("basket_total", partial: "baskets/total", locals: { basket: @basket, basket_total: @basket_total }),
          turbo_stream.replace("basket_actions", partial: "baskets/actions", locals: { basket_total: @basket_total })
        ]
      end
    else
      head :not_found
    end
  end

  private

  def set_basket
    @basket = JSON.parse(cookies[:basket] ||= "{}")
    @basket_total = calculate_basket_total(@basket)
  end

  def calculate_basket_total(basket)
    basket.values.sum { |item| item["price"] } / 100.0
  end
end
