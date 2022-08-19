import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="hamburger"
export default class extends Controller {
  toggle() {
    document.getElementById("navbar-cta").classList.toggle("hidden");
  }
}
