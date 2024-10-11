class Checkout < ApplicationRecord
  def self.create_stripe_session(basket)
    #image = Rails.application.routes.url_helpers.root_url + ActionController::Base.helpers.image_url("bacon-eggs.jpg")
    image = 'https://www.tamingtwins.com/wp-content/uploads/2024/06/air-fryer-bacon-8.jpg'

    line_items = basket.map do |key, item|
      {
        price_data: {
          currency: 'gbp',
          product_data: {
            name: item['product_name'],
            description: description(item),
            images: [image]
          },
          unit_amount: item['price'],
        },
        quantity: 1,
      }
    end

    Stripe::Checkout::Session.create(
      {
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      phone_number_collection: {
        enabled: true
      },
      shipping_address_collection: { allowed_countries: ["GB"] },
      success_url: Rails.application.routes.url_helpers.root_url,
      cancel_url: Rails.application.routes.url_helpers.basket_url },
      { api_key: ENV['STRIPE_SECRET_KEY']}
    )
  end

  private

  def self.description(item)
    "#{item['cure'].capitalize} cure, #{item['smoke'].capitalize}, #{item['sliced']}"
  end
end