import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

// Connects to data-controller="image-drop"
export default class extends Controller {
  static targets = ["fileInput", "dropArea"];

  connect() {
    this.dropAreaTarget.addEventListener("dragover", (event) =>
      this.dragOver(event)
    );
    this.dropAreaTarget.addEventListener("dragleave", (event) =>
      this.dragLeave(event)
    );
    this.dropAreaTarget.addEventListener("drop", (event) => this.drop(event));
    this.fileInputTarget.addEventListener("change", (event) =>
      this.handleFileChange(event)
    );
  }

  dragOver(event) {
    event.preventDefault();
    this.dropAreaTarget.classList.add("active-drop");
  }

  dragLeave(event) {
    event.preventDefault();
    this.dropAreaTarget.classList.remove("active-drop");
  }

  drop(event) {
    event.preventDefault();
    this.dropAreaTarget.classList.remove("active-drop");
    const file = event.dataTransfer.files[0];
    this.handleFileChange({ target: { files: [file] } });
  }

  handleFileChange(event) {
    const file = event.target.files[0];
    if (this.isValidFile(file)) {
      this.uploadFile(file);
    }
  }

  isValidFile(file) {
    const validTypes = ["image/jpeg", "image/jpg", "image/gif", "image/png"];
    const maxSize = 5 * 1024 * 1024; // 5MB
    const minSize = 1 * 1024; // 1KB

    if (!validTypes.includes(file.type)) {
      alert("Invalid file type. Only JPEG, JPG, GIF, and PNG are allowed.");
      return false;
    }
    if (file.size > maxSize) {
      alert("File size exceeds the 5MB limit.");
      return false;
    }
    if (file.size < minSize) {
      alert("File size is below the 1KB limit.");
      return false;
    }
    return true;
  }

  selectFile() {
    this.fileInputTarget.click();
  }

  uploadFile(file) {
    window.addEventListener("beforeunload", this.preventNavigation);

    const uploadUrl = this.fileInputTarget.getAttribute("direct-upload-url");
    const upload = new DirectUpload(file, uploadUrl);

    upload.create((error, blob) => {
      window.removeEventListener("beforeunload", this.preventNavigation);

      if (error) {
        console.error(`An error occurred while uploading the file: ${error}`);
        alert("An error occurred while uploading the file.");
      } else {
        const hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "organization[logo]");
        hiddenField.setAttribute("value", blob.signed_id);
        this.element.appendChild(hiddenField);
        this.element.submit();
      }
    });
  }

  preventNavigation(event) {
    event.preventDefault();
    event.returnValue =
      "An upload is currently in progress. Leaving the page may interrupt the process. Are you sure you want to leave?";
  }
}
