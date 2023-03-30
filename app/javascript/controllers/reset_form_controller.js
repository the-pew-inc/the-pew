import { Controller } from "@hotwired/stimulus";

// This controller is used to reset the question form after the form was
// submitted. In order to reset the maxchar counter to 0 after the form
// is resetted, this method dispatches a custom event named "reset-question-form"

// Connects to data-controller="reset-form"
export default class extends Controller {
  reset() {
    this.element.reset();
    const event = new CustomEvent("reset-question-form");
    window.dispatchEvent(event);
  }
}
