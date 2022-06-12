import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="close-flash"
export default class extends Controller {
  static targets = ["flash"];
  static values = {
    delay: { type: Number, default: 4500 },
  };

  connect() {
    if (this.delayValue > 0) {
      setTimeout(() => {
        this.close();
      }, this.delayValue);
    }
  }

  close() {
    this.flashTarget.classList.add(
      "scale-y-0",
      "-translate-y-7",
      "transition-all",
      "duration-300",
      "ease-out"
    );
    setTimeout(() => {
      this.flashTarget.remove();
    }, 900);
  }
}
