class BasketsController < ApplicationController
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
      render turbo_stream: [
        turbo_stream.remove("basket_item_#{item_key}"),
        turbo_stream.replace("basket_total", partial: "baskets/total", locals: { basket: @basket })
      ]
    else
      head :not_found
    end
  end
end
