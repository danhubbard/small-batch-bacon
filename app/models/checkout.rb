class Checkout < ApplicationRecord
  def self.create_stripe_session(basket)
    #image = Rails.application.routes.url_helpers.root_url + ActionController::Base.helpers.image_url("bacon-eggs.jpg")
    image = 'https://www.tamingtwins.com/wp-content/uploads/2024/06/air-fryer-bacon-8.jpg'

    Rails.logger.info("Image URL: #{image}")

    line_items = basket.map do |key, item|
      {
        price_data: {
          currency: 'gbp',
          product_data: {
            name: "Hand Cured #{item['cut'].capitalize} Bacon",
            description: description(item),
            images: [image]
          },
          unit_amount: item['price'],
        },
        quantity: 1,
      }
    end

    Rails.logger.info("Line items: #{line_items}")

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
  rescue => e
    Rails.logger.error("Error creating Stripe session: #{e.message}")
    nil
  end

  private

  def self.description(item)
    "Options: #{item['weight']}, #{item['smoke'].capitalize}, #{item['sliced']}"
  end

  def self.calculate_price(weight)
    case weight
    when '250g'
      600
    when '500g'
      1200
    when '1kg'
      2000
    when '2kg'
      4000
    else
      0
    end
  end
end