import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="maxchar"
// Used to limit the number of character in a text input or field.
export default class extends Controller {
  static targets = ["input", "msg"];
  static values = {
    maxchars: { type: Number, default: 250 },
    defaultmsg: String,
    errormsg: String,
  };

  connect() {
    this.defaultmsgValue = `Max: ${this.maxcharsValue} characters.`;
    this.errormsgValue = `You have reached the limit of ${this.maxcharsValue} characters`;
  }

  onchange(event) {
    this.currentchars = this.inputTarget.value.length;
    if (this.currentchars > this.maxcharsValue) {
      // cut the input value to maxchar
      this.inputTarget.value = this.inputTarget.value.substring(
        0,
        this.maxcharsValue
      );
      // indicate to the user that the maxchars value has been reached
      this.msgTarget.innerText = this.errormsgValue;
    } else {
      // update the counter msg
      this.msgTarget.innerText = `${this.currentchars} / ${this.maxcharsValue}`;
    }
    if (this.currentchars === 0) {
      // display the default message
      this.msgTarget.innerText = this.defaultmsgValue;
    }
  }
}