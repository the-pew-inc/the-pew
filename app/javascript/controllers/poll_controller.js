import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="poll"
export default class extends Controller {
  static targets = ["button", "progress", "progressBar"];
  static values = { duration: Number };

  connect() {
    if (this.hasDurationValue && this.durationValue > 0) {
      this.hideOptionsAfter(this.durationValue);
      this.startProgressBar();
    } else {
      this.hideProgressBar();
    }
  }

  click() {
    if (
      this.buttonTarget.classList.contains("border-sky-500") &&
      this.buttonTarget.classList.contains("text-sky-500")
    ) {
      this.buttonTarget.classList.remove("border-sky-500", "text-sky-500");
      this.buttonTarget.classList.add("border-slate-500", "text-gray-500");
    } else {
      this.buttonTarget.classList.remove("border-slate-500", "text-gray-500");
      this.buttonTarget.classList.add("border-sky-500", "text-sky-500");
    }
  }

  hideOptionsAfter(duration) {
    if (duration > 0) {
      setTimeout(() => {
        this.element.remove();
      }, (duration + 1) * 1000);
    }
  }

  hideProgressBar() {
    this.progressBarTarget.classList.add("hidden");
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
