import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static targets = ["modal"];

  // close the modal on successful form submission
  // action: "turbo:submit-end->turbo-modal#submitEnd"
  submitEnd(e) {
    if (e.detail.success) {
      this.close(e);
    }
  }

  // close the modal
  close(e) {
    e.preventDefault();
    this.modalTarget.innerHTML = "";
    this.modalTarget.removeAttribute("src");
    this.modalTarget.removeAttribute("complete");
  }
}
