// app/javascript/controllers/poll_options_controller.js

import { Controller } from "@hotwired/stimulus";

//  Used to add / remove poll options when creating or editing a poll
export default class extends Controller {
  static targets = ["container", "template", "error"];

  connect() {
    if (this.pollOptions.length < 1) {
      this.errorTarget.style.display = "block";
    }
  }

  addOption(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(
      /TEMPLATE/g,
      this.pollOptions.length
    );
    this.containerTarget.insertAdjacentHTML("beforeend", content);
    if (this.pollOptions.length < 1) {
      this.errorTarget.style.display = "block";
    }
    if (this.pollOptions.length >= 1) {
      this.errorTarget.style.display = "none";
    }
  }

  removeOption(event) {
    event.preventDefault();
    const option = event.currentTarget.closest("[data-poll-option]");
    option.querySelector("input[name*='_destroy']").value = 1;
    option.style.display = "none";
    if (this.pollOptions.length < 2) {
      this.errorTarget.style.display = "block";
    }
  }

  get pollOptions() {
    return this.containerTarget.querySelectorAll(
      "[data-poll-option]:not([style*='display: none'])"
    );
  }

  get templateTarget() {
    return this.targets.find("template");
  }

  get errorTarget() {
    return this.targets.find("error");
  }
}
