import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="order-questions"
export default class extends Controller {
  static targets = ["question"];
  static values = ["question"];

  connect() {
    // console.debug("Connecting order-question");
    this.observer = new MutationObserver(this.update.bind(this));
    this.observer.observe(this.element, {
      childList: true,
      attributes: false,
      subtree: true,
      // characterData: true,
      // attributeFilter: ["id"],
    });
    // console.debug("Connecting connect initializing the first update");
    this.update();
  }

  disconnect() {
    console.debug("Disconnecting order-question");
    this.observer.disconnect();
  }

  update(event) {
    // console.debug(event);
    this.questions = this.questionTargets;
    console.debug(this.questions);
  }
}
