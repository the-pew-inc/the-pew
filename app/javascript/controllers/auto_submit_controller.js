import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="auto-submit"
export default class extends Controller {
  submit() {
    Rails.fire(this.element, "submit");
    // onchange: 'this.form.requestSubmit()'
  }
}
