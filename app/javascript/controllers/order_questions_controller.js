import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="order-questions"
export default class extends Controller {
  static targets = ["item"];

  connect() {
    this.observer = new MutationObserver(this.update.bind(this));
    this.observer.observe(this.element, {
      childList: true,
      attributes: false,
      subtree: true,
    });
    this.update();
  }

  disconnect() {
    this.observer.disconnect();
  }

  update() {
    // console.debug("We are the champions");
    console.debug(this.itemTargets);
  }
}
