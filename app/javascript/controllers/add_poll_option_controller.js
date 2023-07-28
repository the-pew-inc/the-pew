import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="add-poll-option"
export default class extends Controller {
  static values = {
    allowUserOption: { type: Boolean, default: false },
  };

  connect() {
    if (this.allowUserOptionValue) {
      this.observer = new MutationObserver((mutationsList) => {
        for (let mutation of mutationsList) {
          if (mutation.type === "childList") {
            for (let node of mutation.removedNodes) {
              if (node.id === "poll-submission") {
                // "poll-submission" section removed then open the modal
                this.toggleModal();
              }
            }
          }
        }
      });
      this.observer.observe(document.body, { childList: true, subtree: true });
    }
  }

  disconnect() {
    this.observer.disconnect();
  }

  toggleModal() {
    const $targetEl = document.getElementById("optionModal");
    if ($targetEl) {
      console.debug("We found the modal on the page");
      const optionModal = new Modal($targetEl, null);
      optionModal.toggle();
    } else {
      console.error("optionModal element not found");
    }
  }
}
