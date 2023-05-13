import { Application } from "@hotwired/stimulus";
import { Autocomplete } from "stimulus-autocomplete";
// import * as Honeybadger from "@honeybadger-io/js";

// Start Stimulus App
const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

// Registering the autocomplete-stimulus js library
application.register("autocomplete", Autocomplete);

export { application };
