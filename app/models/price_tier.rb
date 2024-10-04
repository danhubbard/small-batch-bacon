class PriceTier < ApplicationRecord
  belongs_to :product
  
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, presence: true, numericality: { greater_than: 0 }, if: -> { product.by_weight? }
  
  validate :ensure_single_tier_for_per_unit_products
  
  private
  
  def ensure_single_tier_for_per_unit_products
    if product.per_unit? && product.price_tiers.count > 1
      errors.add(:base, "Per-unit products can only have one price tier")
    end
  end
end