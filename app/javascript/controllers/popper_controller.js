import { Controller } from "@hotwired/stimulus";
import { createPopper } from "@popperjs/core";
// import { createPopper } from "@popperjs/core/lib/popper-lite.js";
// import preventOverflow from "@popperjs/core/lib/modifiers/preventOverflow.js";
// import flip from "@popperjs/core/lib/modifiers/flip.js";

// Connects to data-controller="popper"
export default class extends Controller {
  static targets = ["element", "tooltip"];
  static values = {
    placement: { type: String, default: "top" },
    offset: { type: Array, default: [0, 8] },
    delay: { type: Number, default: 500 },
  };

  connect() {
    this.popperInstance = createPopper(this.elementTarget, this.tooltipTarget, {
      placement: this.placementValue,
      modifiers: [
        {
          name: "offset",
          options: {
            offset: [0, 8],
          },
        },
      ],
    });
  }

  show() {
    this.timeout = setTimeout(() => {
      // Make the tooltip visible
      this.tooltipTarget.setAttribute("data-show", "");

      // Enable the event listeners
      this.popperInstance.setOptions((options) => ({
        ...options,
        modifiers: [
          ...options.modifiers,
          { name: "eventListeners", enabled: true },
        ],
      }));

      // Update its position
      this.popperInstance.update();
    }, this.delayValue);
  }

  hide() {
    // Remove the timeout
    clearTimeout(this.timeout);

    // Hide the tooltip
    this.tooltipTarget.removeAttribute("data-show");

    // Disable the event listeners
    this.popperInstance.setOptions((options) => ({
      ...options,
      modifiers: [
        ...options.modifiers,
        { name: "eventListeners", enabled: false },
      ],
    }));
  }

  disconnect() {
    if (this.popperInstance) {
      this.popperInstance.destroy();
    }
  }
}
