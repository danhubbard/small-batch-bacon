# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Clearing existing data..."
Product.destroy_all
PriceTier.destroy_all

# Create Products
puts "Creating products..."
back_bacon = Product.create!(
  name: "Back Bacon",
  category: "bacon",
  pricing_type: "by_weight",
  image: "back.jpg"
)

streaky_bacon = Product.create!(
  name: "Streaky Bacon",
  category: "bacon",
  pricing_type: "by_weight",
  image: "streaky.jpg"
)

# Create Price Tiers
puts "Creating price tiers..."
PriceTier.create!([
  { product: streaky_bacon, price: 6.0, weight: 250 },
  { product: streaky_bacon, price: 12.0, weight: 500 },
  { product: streaky_bacon, price: 20.0, weight: 1000 },
  { product: back_bacon, price: 23.0, weight: 1000 },
  { product: back_bacon, price: 7.5, weight: 250 }
])

puts "Seed data created successfully!"
puts "Created #{Product.count} products and #{PriceTier.count} price tiers."
