class Product < ApplicationRecord
  has_many :price_tiers, dependent: :destroy
  
  enum pricing_type: { per_unit: 0, by_weight: 1 }
  enum category: { bacon: 0, book: 1 }
  
  validates :name, presence: true
  validates :pricing_type, presence: true
  validates :category, presence: true
  
  def price_for(quantity_or_weight)
    return price_tiers.first.price if per_unit?
    
    price_tiers.where('weight <= ?', quantity_or_weight)
               .order(weight: :desc)
               .first&.price
  end
end
