import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priceDisplay", "weightRadio", "priceField"]

  connect() {
    // Parse the price tiers JSON
    this.priceTiers = JSON.parse(this.element.dataset.productPriceTiers)
    this.updatePrice()
  }

  updatePrice() {
    const selectedWeight = this.weightRadioTargets.find(radio => radio.checked)
    if (selectedWeight) {
      const weight = parseFloat(selectedWeight.value)
      const price = this.calculatePrice(weight)
      this.priceDisplayTarget.innerText = `£${price.toFixed(2)}`
      this.priceFieldTarget.value = Math.round(price * 100) // Store in cents
    }
  }

  calculatePrice(weight) {
    const priceTier = this.priceTiers.find(tier => parseFloat(tier.weight) === weight)
    return priceTier ? parseFloat(priceTier.price) : 0
  }
}