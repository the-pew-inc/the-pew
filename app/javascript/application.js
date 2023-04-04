// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "flowbite/dist/datepicker.turbo.js";
import "flowbite/dist/flowbite.turbo.js";
import "chartkick/chart.js";

// document.addEventListener("turbo:load", function () {
//   console.log("Ready triggered!");
// });
import "trix";
import "@rails/actiontext";

// Preventing file upload in Trix
document.addEventListener("trix-file-accept", (e) => {
  e.preventDefault();
});
