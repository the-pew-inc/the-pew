import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="auto-submit"
export default class extends Controller {
  change(event) {
    event.preventDefault();
    // Rails.fire(this.element, "submit");
    // Turbo.navigator.submitForm(this.formTarget)
    // this.formTarget.requestSubmit
    Turbo.navigator.submitForm(this.element);
  }
}
