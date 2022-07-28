// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "flowbite";

// document.addEventListener("turbo:load", function () {
//   console.log("Ready triggered!");
// });

// Still a work in progress
// based on https://github.com/themesberg/flowbite/issues/88
// https://discuss.rubyonrails.org/t/struggling-with-javascript-and-esbuild-rails-7/79698/3
// https://github.com/naecoo/esbuild-plugin-replace
// window.document.addEventListener("turbo:load", (event) => {
//   // trigger flowbite events
//   window.document.dispatchEvent(
//     new Event("DOMContentLoaded", {
//       bubbles: true,
//       cancelable: true,
//     })
//   );
// });

// Listen for dark/light mode system changes.
window
  .matchMedia("(prefers-color-scheme: dark)")
  .addEventListener("change", (event) => {
    const newColorScheme = event.matches ? "dark" : "light";
  });

if (window.matchMedia) {
  // Check if the dark-mode Media-Query matches
  if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
    // Dark
    console.log("system prefers dark mode");
  } else {
    // Light
    console.log("system prefers light mode");
  }
} else {
  // Default (when Media-Queries are not supported)
  console.log("system has no preference");
}

// Handle Dark and Light modes
const themeToggleDarkIcon = document.getElementById("theme-toggle-dark-icon");
const themeToggleLightIcon = document.getElementById("theme-toggle-light-icon");

// Change the icons inside the button based on previous settings
if (
  localStorage.getItem("color-theme") === "dark" ||
  (!("color-theme" in localStorage) &&
    window.matchMedia("(prefers-color-scheme: dark)").matches)
) {
  themeToggleLightIcon.classList.remove("hidden");
} else {
  themeToggleDarkIcon.classList.remove("hidden");
}

const themeToggleBtn = document.getElementById("theme-toggle");

themeToggleBtn.addEventListener("click", function () {
  // toggle icons inside button
  themeToggleDarkIcon.classList.toggle("hidden");
  themeToggleLightIcon.classList.toggle("hidden");

  // if set via local storage previously
  if (localStorage.getItem("color-theme")) {
    if (localStorage.getItem("color-theme") === "light") {
      document.documentElement.classList.add("dark");
      localStorage.setItem("color-theme", "dark");
    } else {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("color-theme", "light");
    }

    // if NOT set via local storage previously
  } else {
    if (document.documentElement.classList.contains("dark")) {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("color-theme", "light");
    } else {
      document.documentElement.classList.add("dark");
      localStorage.setItem("color-theme", "dark");
    }
  }
});
