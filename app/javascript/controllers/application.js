import { Application } from "@hotwired/stimulus";
import { Autocomplete } from "stimulus-autocomplete";
// import * as Honeybadger from "@honeybadger-io/js";

// Configure honeybadger.js
// Honeybadger.configure({
//   apiKey: process.env.HONEYBADGER_API_KEY,
//   environment: "production",
//   revision: "git SHA/project version",
// });

// Start Stimulus App
const application = Application.start();

// Set up Honeybadger error handler
// application.handleError = (error, message, detail) => {
//   console.warn(message, detail);
//   Honeybadger.notify(error);
// };

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

application.register("autocomplete", Autocomplete);

export { application };
