class CheckoutsController < ApplicationController
  def show
    clear_basket
  end

  def create
    basket = parse_basket
    return redirect_to_basket if basket.empty?

    session = create_stripe_session(basket)
    redirect_to_stripe(session)
  end

  private

  def clear_basket
    cookies.delete(:basket)
  end

  def parse_basket
    JSON.parse(cookies[:basket] ||= '{}')
  end

  def redirect_to_basket
    redirect_to basket_path
  end

  def redirect_to_stripe(session)
    redirect_to session.url, allow_other_host: true
  end

  def create_stripe_session(basket)
    Stripe::Checkout::Session.create(stripe_session_params(basket), stripe_api_key)
  end

  def stripe_session_params(basket)
    {
      payment_method_types: ['card'],
      line_items: build_line_items(basket),
      mode: 'payment',
      phone_number_collection: { enabled: true },
      shipping_address_collection: { allowed_countries: ['GB'] },
      success_url: checkout_url('complete'),
      cancel_url: basket_url
    }
  end

  def stripe_api_key
    { api_key: ENV['STRIPE_SECRET_KEY'] }
  end

  def build_line_items(basket)
    basket.map do |_, item|
      {
        price_data: price_data(item),
        quantity: 1
      }
    end
  end

  def price_data(item)
    {
      currency: 'gbp',
      product_data: product_data(item),
      unit_amount: item['price']
    }
  end

  def product_data(item)
    {
      name: item['product_name'],
      description: generate_description(item),
      images: [product_image_url]
    }
  end

  def generate_description(item)
    "#{item['cure'].capitalize} cure, #{item['smoke'].capitalize}, #{item['sliced']}"
  end

  def product_image_url
    'https://www.tamingtwins.com/wp-content/uploads/2024/06/air-fryer-bacon-8.jpg'
  end
end
