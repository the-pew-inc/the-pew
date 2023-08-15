import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-invites"
export default class extends Controller {
  static targets = ["searchInput", "badgeContainer", "invitedUsers"];
  static values = {
    invitedUsers: { type: Array, default: [] },
  };

  connect() {
    // Clear inviterUsers from any previous value that might still be haging somewhere ;-)
    this.invitedUsersValue = [];

    // Get the autocomplete object from the page
    this.autocomplete = document.getElementById("autocomplete");

    autocomplete.addEventListener("autocomplete.change", (event) => {
      // Get the email address or group id
      var invited = this.extractTypeAndId(event.detail.value);
      invited.label = event.detail.textValue;

      this.addBadge(invited);
    });
  }

  clear(event) {
    // Prevent form submission
    event.preventDefault();

    // Clear the search input field
    this.searchInputTarget.value = "";
  }

  disconnect() {
    // Remove the autocomplete listener
    if (this.autocomplete) {
      this.autocomplete.removeEventListener(
        "autocomplete.change",
        this.autocompleteListener
      );
    }
    this.invitedUsersValue = [];
    this.invitedUsersTarget.value = JSON.stringify(this.invitedUsersValue);
  }

  addBadge(invited) {
    // Append the email to the invitedUser Array
    // ✅ only appends if value not in array
    if (!this.invitedUsersValue.some((user) => user.label === invited.label)) {
      this.invitedUsersValue.push(invited);
    } else {
      alert(`${this.searchInputTarget.value} is already in the list`);
      this.searchInputTarget.value = "";
      return;
    }

    // Create a new badge and add it to the badge container
    this.badgeContainerTarget.innerHTML += `
      <span class="inline-flex items-center px-2 py-1 mr-2 text-sm font-medium text-blue-800 bg-blue-100 rounded dark:bg-blue-900 dark:text-blue-300" data-id="${invited.id}" data-type="${invited.type}" data-label="${invited.label}">
        ${invited.label}
        <button type="button" data-action="user-invites#removeBadge" class="inline-flex items-center p-1 ml-2 text-sm text-blue-400 bg-transparent rounded-sm hover:bg-blue-200 hover:text-blue-900 dark:hover:bg-blue-800 dark:hover:text-blue-300" aria-label="Remove">
          <svg class="w-2 h-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
          </svg>
          <span class="sr-only">Remove badge</span>
        </button>
      </span>
    `;

    // Clear the search input field
    this.searchInputTarget.value = "";

    // Serialize the invitedUsersValue as JSON and store it in the hidden input
    this.invitedUsersTarget.value = JSON.stringify(this.invitedUsersValue);
  }

  addEmail(event) {
    // Prevent form submission
    event.preventDefault();

    // 1. Extract the value of searchInputTarget
    const email = this.searchInputTarget.value.trim();

    // 2. Ensure that the searchInputTarget value is a valid email address
    if (this.isValidEmail(email)) {
      this.addBadge({ id: "", type: "new_email", label: email });
    } else {
      alert("Please enter a valid email address.");
    }
  }

  extractTypeAndId(str) {
    const match = str.match(/^(\w+)_([\w-]+)$/);

    if (match) {
      return {
        type: match[1],
        id: match[2],
      };
    } else {
      return null;
    }
  }

  // Utility function to validate email address using a simple regex
  isValidEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // simple email validation regex
    return regex.test(email);
  }

  removeBadge(event) {
    const badgeElement = event.target.closest("[data-id]"); // Find the parent badge of the clicked button
    const id = badgeElement.getAttribute("data-id");
    const type = badgeElement.getAttribute("data-type");
    const label = badgeElement.getAttribute("data-label");

    // Remove the badge from the UI
    badgeElement.remove();

    // Remove the corresponding object from the invitedUsers array
    this.invitedUsersValue = this.invitedUsersValue.filter((user) => {
      return !(user.id === id && user.type === type && user.label === label);
    });

    // Update the invitedUsersField hidden input to reflect the changes
    this.invitedUsersTarget.value = JSON.stringify(this.invitedUsersValue);
  }
}
