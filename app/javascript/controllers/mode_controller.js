import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="mode"
export default class extends Controller {
  static targets = ["darkIcon", "lightIcon"];
  connect() {
    if (localStorage.getItem("color-theme")) {
      if (localStorage.getItem("color-theme") === "light") {
        // Light mode
        this.lightMode();
      } else {
        // Dark mode
        this.darkMode();
      }
    } else {
      if (window.matchMedia) {
        // Check if the dark-mode Media-Query matches
        if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
          // Dark
          this.lightIconTarget.classList.toggle("hidden");
          document.documentElement.classList.add("dark");
        } else {
          // Light
          this.darkIconTarget.classList.toggle("hidden");
          document.documentElement.classList.remove("dark");
        }
      } else {
        // Default (when Media-Queries are not supported)
        // Default to Light Mode
        this.lightMode();
      }
    }
  }

  toggleMode() {
    this.lightIconTarget.classList.toggle("hidden");
    this.darkIconTarget.classList.toggle("hidden");

    if (this.lightIconTarget.classList.contains("hidden")) {
      // User is requesting the light mode, we display the dark mode icon
      localStorage.setItem("color-theme", "light");
      document.documentElement.classList.remove("dark");
    } else {
      // User is requesting the dark mode, we display the light mode icon
      localStorage.setItem("color-theme", "dark");
      document.documentElement.classList.add("dark");
    }
  }

  darkMode() {
    this.darkIconTarget.classList.add("hidden");
    this.lightIconTarget.classList.remove("hidden");
    document.documentElement.classList.add("dark");
  }

  lightMode() {
    this.lightIconTarget.classList.add("hidden");
    this.darkIconTarget.classList.remove("hidden");
    document.documentElement.classList.remove("dark");
  }
}
