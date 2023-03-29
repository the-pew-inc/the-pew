import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="submit-question"
export default class extends Controller {
  submit(event) {
    // As we need a turbo stream we cannot use form.submit, we need to call form.requestSubmit
    // Another approach would be to use something like Turbo.navigator.submitForm(this.formTarget)
    // but for now we will stick to something simple as it does the job.
    this.element.requestSubmit();
  }
}
