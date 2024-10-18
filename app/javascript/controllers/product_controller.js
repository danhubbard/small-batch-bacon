import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priceDisplay", "weightRadio", "priceField", "submitButton"]

  connect() {
    // Parse the price tiers JSON
    this.priceTiers = JSON.parse(this.element.dataset.productPriceTiers)
    this.updatePrice()
    this.checkFormValidity()
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

  checkFormValidity() {
    const form = this.element.querySelector('form')
    const isValid = form.checkValidity()
    this.submitButtonTarget.disabled = !isValid
  }
}
