import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="filter-users"
export default class extends Controller {
  connect() {
    // Get the autocomplete object from the page
    const autocomplete = document.getElementById("autocomplete");

    autocomplete.addEventListener("autocomplete.change", (event) => {
      // Get the user_id for the selected user
      this.selected_user_id = "user_" + event.detail.value;

      // List all the users in the user-list
      const user_list = document.getElementById("user-list");
      this.users = user_list.getElementsByTagName("tr");

      // Loop through the table rows and hide the non selected users
      this.toggleUsers();
    });
  }

  clear() {
    if (this.selected_user_id) {
      // Loop through the table rows and display the non selected users
      this.toggleUsers();
    }
  }

  toggleUsers() {
    for (let i = 0; i < this.users.length; i++) {
      const user = this.users[i];
      if (user.id !== this.selected_user_id) {
        user.classList.toggle("hidden");
      }
    }
  }
}
