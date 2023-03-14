import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  // hide modal on successful form submission
  // action: "turbo:submit-end->turbo-modal#submitEnd"
  submitEnd(e) {
    if (e.detail.success) {
      this.hideModal();
    }
  }

  hideModal() {
    this.element.parentElement.removeAttribute("src");
    this.element.remove();
  }
}
