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
      this.uploadFile(event.target.files[0])
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
    this.uploadFile(file);
  }

  selectFile() {
    this.fileInputTarget.click();
  }

  uploadFile(file) {
    const uploadUrl = this.fileInputTarget.getAttribute("direct-upload-url");

    const upload = new DirectUpload(file, uploadUrl);

    upload.create((error, blob) => {
      if (error) {
        // Handle the error
        console.error(`An error occured while uploading the file`);
        alert("An error occured while uploading the file.");
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
}
