import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="close-dropdown"
// data-action="turbo:submit-end->close-dropdown#close"
export default class extends Controller {
  close() {
    const dropdown = document.getElementById("dropdownAction");
    dropdown.classList.toggle("hidden");
  }
}
