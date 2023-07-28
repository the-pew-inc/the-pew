import { Controller } from "@hotwired/stimulus";
import { Modal } from "flowbite";

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
                // "poll-submission" section removed, open the modal
                const $targetEl = document.getElementById("optionModal");
                if ($targetEl) {
                  const optionModal = new Modal($targetEl, null);
                  optionModal.show();
                } else {
                  console.error("optionModal element not found");
                }
              }
            }
            // for (let node of mutation.addedNodes) {
            //   if (node.id === "poll-submission") {
            //     // "poll-submission" section added, do something here
            //   }
            // }
          }
        }
      });
      this.observer.observe(document.body, { childList: true, subtree: true });
    }
  }

  disconnect() {
    this.observer.disconnect();
  }
}
