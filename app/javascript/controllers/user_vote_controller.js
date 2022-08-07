import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-vote"
export default class extends Controller {
  static targets = ["button"];
  click() {
    if (
      this.buttonTarget.classList.contains("border-sky-500") &&
      this.buttonTarget.classList.contains("text-sky-500")
    ) {
      this.buttonTarget.classList.remove("border-sky-500");
      this.buttonTarget.classList.remove("text-sky-500");
      this.buttonTarget.classList.add("border-slate-500");
      this.buttonTarget.classList.add("text-gray-500");
    } else {
      this.buttonTarget.classList.remove("border-slate-500");
      this.buttonTarget.classList.remove("text-gray-500");
      this.buttonTarget.classList.add("border-sky-500");
      this.buttonTarget.classList.add("text-sky-500");
    }
  }
}
