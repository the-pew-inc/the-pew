import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["toggeable"];

  toggle() {
    this.toggeableTarget.classList.toggle("hidden");
  }
}
