import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="validate-pin"
export default class extends Controller {
  static targets = ["pin", "pinError"];

  change(event) {
    const pin = this.pinTarget.value;
    if (pin.length > 6) {
      this.pinErrorTarget.classList.remove("hidden");
      this.pinTarget.value = pin.substring(0, 6);
    }

    if (pin.length < 6 && !this.pinErrorTarget.classList.contains("hidden")) {
      this.pinErrorTarget.classList.add("hidden");
    }
  }

  clear(event) {
    this.pinTarget.value = "";
  }
}
