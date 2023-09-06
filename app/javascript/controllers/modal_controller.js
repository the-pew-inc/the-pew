import { Controller } from "@hotwired/stimulus";

// Description: this controller is used to hide a modal or toggle a modal using CSS
// it must not be confused with the turbo-modal controller that is used for turbo-frame
// based modals and not to be confused with the Flowbite modal as well.
// It can also be used to toggle modal using the toggle method.

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    console.debug(`Loading the modal stimulus controller`);
    console.debug(this.element);
  }

  // data-action="modal#close"
  close(e) {
    // prevent any form submission or other unwanted action to take place
    e.preventDefault();

    // retrieve the modal and hide it
    const modal = this.element;
    modal.setAttribute("aria-hidden", "true");
    if (!modal.classList.contains("hidden")) {
      modal.classList.add("hidden");
    }
  }

  // data-action="modal#toggle"
  toggle(e) {
    // prevent any form submission or other unwanted action to take place
    e.preventDefault();

    // toggle the modal
    const modal = this.element;
    modal.classList.toggle("hidden");
  }
}
