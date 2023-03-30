import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="time-zone"
export default class extends Controller {
  static values = {
    domain: { type: String, default: "localhost" },
  };

  connect() {
    // Set the user's timezone based on their browser timezone configuration
    // and save it to a cookie (which expires 1 day from its creation time)
    // If the cookie is not expired, we read the timezone from the cookie instead.
    if (this.readTimezoneCookie() === undefined) {
      this.saveTimezoneCookie();
    }
  }

  saveTimezoneCookie() {
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    let expires = new Date();
    expires.setTime(expires.getTime() + 60 * 60 * 24 * 1000);
    expires = expires.toGMTString();
    document.cookie = `timezone=${timezone};expires=${expires};path=/`;
  }

  readTimezoneCookie() {
    const name = "timezone=";
    const cDecoded = decodeURIComponent(document.cookie); //to be careful
    const cArr = cDecoded.split("; ");
    let res;
    cArr.forEach((val) => {
      if (val.indexOf(name) === 0) res = val.substring(name.length);
    });
    return res;
  }

  offsetToUTC() {
    const date = new Date();
    return date.getTimezoneOffset();
  }
}
