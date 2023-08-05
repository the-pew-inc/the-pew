import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-invites"
export default class extends Controller {
  static targets = ["searchInput", "invitedUsers", "badgeContainer"];

  addBadge(event) {
    // Prevent the form from submitting when enter is pressed
    event.preventDefault();

    // Get the selected user's email or manually entered email
    const email = this.searchInputTarget.value;

    // Add this email to the list of invited users
    this.invitedUsersTarget.value += email + ",";

    // Create a new badge and add it to the badge container
    this.badgeContainerTarget.innerHTML += `
      <span class="inline-flex items-center px-2 py-1 mr-2 text-sm font-medium text-blue-800 bg-blue-100 rounded dark:bg-blue-900 dark:text-blue-300" data-email="${email}">
        ${email}
        <button type="button" class="inline-flex items-center p-1 ml-2 text-sm text-blue-400 bg-transparent rounded-sm hover:bg-blue-200 hover:text-blue-900 dark:hover:bg-blue-800 dark:hover:text-blue-300" data-action="click->user-invites#removeBadge" aria-label="Remove">
          <svg class="w-2 h-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
          </svg>
          <span class="sr-only">Remove badge</span>
        </button>
      </span>
    `;

    // Clear the search input
    this.searchInputTarget.value = "";
  }

  removeBadge(event) {
    // Get the email of the badge to be removed
    const badgeEmail = event.target.closest("span").dataset.email;

    // Remove this email from the list of invited users
    this.invitedUsersTarget.value = this.invitedUsersTarget.value.replace(
      badgeEmail + ",",
      ""
    );

    // Remove the badge from the badge container
    event.target.closest("span").remove();
  }
}
