import { Application } from "@hotwired/stimulus";
import { Autocomplete } from "stimulus-autocomplete";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

application.register("autocomplete", Autocomplete);

export { application };
