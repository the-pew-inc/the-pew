import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="mode"
// Search localStorage for a pre-defined value. If there is no such value then falls back to the
// system mode (using Media-Queries). If Media-Queries are not supported then falls back to light mode.
export default class extends Controller {
  static targets = ["darkIcon", "lightIcon"];
  connect() {
    const mode = localStorage.getItem("color-theme");
    if (mode) {
      if (mode === "light") {
        // Light mode
        this.lightMode();
      } else {
        // Dark mode
        this.darkMode();
      }
    } else {
      // No stored mode. Aligning with the system mode using Media-Queries when supported
      // Make sure that Media-Queries is enable or supported. If not fall back to light mode
      if (window.matchMedia) {
        // Check if the dark-mode Media-Query matches
        if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
          // Dark
          this.darkMode();
        } else {
          // Light
          this.lightMode();
        }
      } else {
        // Default (when Media-Queries are not supported)
        // Default to Light Mode
        this.lightMode();
      }
    }
  }

  // toggle between the 2 modes
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

  // Set the dark mode
  darkMode() {
    this.darkIconTarget.classList.add("hidden");
    this.lightIconTarget.classList.remove("hidden");
    document.documentElement.classList.add("dark");
  }

  // Set the light mode
  lightMode() {
    this.lightIconTarget.classList.add("hidden");
    this.darkIconTarget.classList.remove("hidden");
    document.documentElement.classList.remove("dark");
  }
}
