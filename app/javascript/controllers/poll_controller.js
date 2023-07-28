import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="poll"
export default class extends Controller {
  static targets = ["button", "progress", "progressBar"];
  static values = {
    duration: Number,
    button_type: String,
    allowUserOption: { type: Boolean, default: false },
  };

  connect() {
    if (this.hasDurationValue && this.durationValue > 0) {
      this.hideOptionsAfter(this.durationValue);
      this.startProgressBar();
      this.displayProgressBar();
    }
  }

  click(event) {
    // 1. Check the status of the other buttons (if any)
    const currentButtonAction = event.params.voteAction;
    const pollOptionId = event.params.pollOptionId;

    // 2. Get all the other buttons
    const buttons = document.querySelectorAll(
      `button[data-poll-poll-option-id-param="${pollOptionId}"]`
    );

    // 3. Run against the button array and apply the proper style
    buttons.forEach((button) => {
      if (button.dataset.pollVoteActionParam !== currentButtonAction) {
        // We revert to inactive if the button is active but not the one
        // the user clicked on.
        if (
          button.firstElementChild.classList.contains("border-sky-500") &&
          button.firstElementChild.classList.contains("text-sky-500")
        ) {
          button.firstElementChild.classList.remove(
            "border-sky-500",
            "text-sky-500"
          );
          button.firstElementChild.classList.add(
            "border-slate-500",
            "text-gray-500"
          );
        }
      } else {
        // We apply the proper style to the button the user clicked on
        if (
          this.buttonTarget.classList.contains("border-sky-500") &&
          this.buttonTarget.classList.contains("text-sky-500")
        ) {
          this.buttonTarget.classList.remove("border-sky-500", "text-sky-500");
          this.buttonTarget.classList.add("border-slate-500", "text-gray-500");
        } else {
          this.buttonTarget.classList.remove(
            "border-slate-500",
            "text-gray-500"
          );
          this.buttonTarget.classList.add("border-sky-500", "text-sky-500");
        }
      }
    });
  }

  displayProgressBar() {
    this.progressBarTarget.classList.remove("hidden");
  }

  hideOptionsAfter(duration) {
    if (duration > 0) {
      setTimeout(() => {
        this.element.remove();
      }, (duration + 1) * 1000);
    }
  }

  startProgressBar() {
    let elapsed = 0;
    const intervalId = setInterval(() => {
      elapsed++;
      const progressPercent = (elapsed / this.durationValue) * 100;
      this.progressTarget.style.width = `${progressPercent}%`;
      if (elapsed >= this.durationValue) {
        clearInterval(intervalId);
      }
    }, 1000);
  }
}
