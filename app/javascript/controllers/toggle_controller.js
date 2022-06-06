import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["toggle"];

  toggle() {
    this.toggleTarget.classList.toggle("hidden");
  }
}
