import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["source", "copy", "copied"];
  copy(e) {
    e.preventDefault();
    navigator.clipboard.writeText(this.sourceTarget.value);
    this.copyTarget.classList.add("hidden");
    this.copiedTarget.classList.remove("hidden");
    setTimeout(() => {
      this.copiedTarget.classList.add("hidden");
      this.copyTarget.classList.remove("hidden");
    }, "1000");
  }
}
