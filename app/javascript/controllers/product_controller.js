import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priceDisplay", "weightRadio", "priceField"]

  connect() {
    this.updatePrice()
  }

  updatePrice() {
    const selectedWeight = this.weightRadioTargets.find(radio => radio.checked)
    if (selectedWeight) {
      const weight = selectedWeight.value
      const price = this.calculatePrice(weight)
      this.priceDisplayTarget.innerText = `£${(price / 100).toFixed(2)}`
      this.priceFieldTarget.value = price
    }
  }

  calculatePrice(weight) {
    switch (weight) {
      case '250g':
        return 600
      case '500g':
        return 1200
      case '1kg':
        return 2000
      case '2kg':
        return 4000
      default:
        return 0
    }
  }
}