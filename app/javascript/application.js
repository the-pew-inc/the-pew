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
