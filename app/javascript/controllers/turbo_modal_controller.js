import { Controller } from "@hotwired/stimulus";

// Description: turbo-modal controller is used to manage the modal created using turbo or turbo-frame
// It is not used to manage modal generated using Flowbite or Flowbite type of UI such as the
// one used by the poll user add option.

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
