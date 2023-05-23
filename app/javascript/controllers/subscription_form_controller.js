import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="subscription-form"
export default class extends Controller {
  static values = {
    maxSeats: Number,
    minSeats: Number,
    pricePerSeatMonthly: Number,
    pricePerSeatYearly: Number,
  };

  static targets = ["toggle", "seats", "totalPrice"];

  connect() {
    this.calculateTotalPrice();
  }

  formatWebsite(event) {
    const websiteInput = event.target;
    const website = websiteInput.value;

    if (website && !website.startsWith("https://")) {
      websiteInput.value = `https://${website.trim()}`;
    }
  }

  validateSeats(event) {
    const seatsInput = event.currentTarget;

    // Ensure seatsInput is not null before accessing its value
    if (!seatsInput) {
      console.error("Seats input element not found.");
      return;
    }

    const seatsValue = seatsInput.value;

    // Clear the input if it's not a valid positive integer
    if (!/^\d+$/.test(seatsValue)) {
      seatsInput.value = String(this.minSeatsValue);
      seatsInput.setSelectionRange(
        seatsInput.value.length,
        seatsInput.value.length
      );
      this.calculateTotalPrice();
      return;
    }

    const seats = parseInt(seatsValue);
    const minSeats = this.minSeatsValue;
    const maxSeats = this.maxSeatsValue;

    // Adjust the value to the nearest integer if it's not already an integer
    if (!Number.isInteger(seats)) {
      seatsInput.value = String(Math.round(seats));
      seatsInput.setSelectionRange(
        seatsInput.value.length,
        seatsInput.value.length
      );
      this.calculateTotalPrice();
      return;
    }

    // Restrict the value to the allowed range
    if (seats < minSeats) {
      seatsInput.value = String(minSeats);
      seatsInput.setSelectionRange(
        seatsInput.value.length,
        seatsInput.value.length
      );
    } else if (seats > maxSeats) {
      if (seatsInput.value !== String(maxSeats)) {
        seatsInput.value = String(maxSeats);
        seatsInput.setSelectionRange(
          seatsInput.value.length,
          seatsInput.value.length
        );
      }
      seatsInput.blur(); // Remove focus from the input element
      this.calculateTotalPrice();
      return;
    }

    // if (seatsInput.value === "") {
    //   seatsInput.setSelectionRange(0, 0); // Set cursor position to the start of the input
    // } else {
    //   seatsInput.focus(); // Place cursor at the end of the input value
    // }

    seatsInput.focus();

    this.calculateTotalPrice();
  }

  calculateTotalPrice() {
    console.debug(`We are in calculateTotalPrice}`);

    const toggleValue = this.toggleTarget.checked;
    const seatsValue = parseInt(this.seatsTarget.value);

    if (isNaN(seatsValue)) {
      return;
    }

    console.debug(`toggle: ${toggleValue}`);
    const pricePerSeat = toggleValue
      ? this.pricePerSeatYearlyValue
      : this.pricePerSeatMonthlyValue;
    const total = pricePerSeat * seatsValue;

    if (this.hasTotalPriceTarget) {
      this.totalPriceTarget.innerHTML = `Total Price: $${total.toFixed(
        2
      )} per ${toggleValue ? "year" : "month"}`;
    }
  }

  onToggleChange() {
    this.calculateTotalPrice();
  }

  onSeatsChange() {
    this.calculateTotalPrice();
  }
}
