import { Controller } from "@hotwired/stimulus";
import JSConfetti from "js-confetti";

// Connects to data-controller="confetti"
export default class extends Controller {
  static targets = ["jsc"];

  connect() {
    this.jsConfetti = new JSConfetti();

    this.jsConfetti.addConfetti();
  }
}
