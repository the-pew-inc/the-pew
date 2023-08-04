import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="invite-toggle"
// Description: used to toggle a section in a form
// Primary user: invite from Poll, Event, Survey management _form.
export default class extends Controller {
  static targets = ["form"];
  static values = { openForm: { type: Boolean, default: false } };

  connect() {
    if (this.openFormValue) {
      this.open();
    } else {
      this.close();
    }
  }

  open() {
    this.formTarget.classList.remove("hidden");
  }

  close() {
    this.formTarget.classList.add("hidden");
  }
}
