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
  image: "back.jpg",
  description: "Cut from the pork loin, located in the back of the pig. It's a relatively lean cut with a wide, meaty section and a smaller fat-streaked portion."
)

streaky_bacon = Product.create!(
  name: "Streaky Bacon",
  category: "bacon",
  pricing_type: "by_weight",
  image: "streaky.jpg",
  description: "Cut from the pork belly, this cut features alternating layers of fat and meat running in narrow strips. The higher fat content allows it to become crispy when cooked."
)

# Create Price Tiers
puts "Creating price tiers..."
PriceTier.create!([
  { product: streaky_bacon, price: 6.5, weight: 250 },
  { product: streaky_bacon, price: 12.0, weight: 500 },
  { product: streaky_bacon, price: 21.0, weight: 1000 },
  { product: back_bacon, price: 7.0, weight: 250 },
  { product: back_bacon, price: 12.5, weight: 500 },
  { product: back_bacon, price: 23.0, weight: 1000 }
])

puts "Seed data created successfully!"
puts "Created #{Product.count} products and #{PriceTier.count} price tiers."
