import { Controller } from "@hotwired/stimulus";
import QRCodeStyling from "qr-code-styling";

// Connects to data-controller="qr-code-generator"
// Description: Used to generate EVENT QR Code on the fly (aka client side)
export default class extends Controller {
  static targets = ["canvas", "container"];
  static values = {
    size: { type: Number, default: 680 }, // Size of the canvas
    logoUrl: String, // company or event logo, https://server.com/path/to/image
    serverUrl: String, // the link to the which the QR Code is pointing
  };

  connect() {
    // Determine the size based on the container's dimensions
    requestAnimationFrame(() => {
      setTimeout(() => {
        this.generateQRCode();
      }, 0);
    });
  }

  generateQRCode() {
    // Dynamic determination of the size
    this.sizeValue = this.containerTarget.offsetWidth;

    // Get the server URL
    // let serverUrl = window.location.origin;

    // Check if the server URL has a trailing slash
    // if (!serverUrl.endsWith("/")) {
    //   // Remove the trailing slash
    //   serverUrl = serverUrl.replace(/\/$/, "");
    // }

    // QR Code params
    let qrCodeParams = {
      width: this.sizeValue,
      height: this.sizeValue,
      type: "svg",
      data: `${this.serverUrlValue}`,
      dotsOptions: {
        color: "#4267b2",
        type: "rounded",
      },
      backgroundOptions: {
        color: "transparent",
      },
    };

    if (this.hasLogoUrlValue && /^https:\/\/.*/.test(this.logoUrlValue)) {
      qrCodeParams.image = this.logoUrlValue;
      qrCodeParams.imageOptions = {
        crossOrigin: "anonymous",
        margin: 20,
      };
    }

    // Generate the QRCode and attached it to the target
    this.qrCode = new QRCodeStyling(qrCodeParams);

    // Display the QRCode
    this.qrCode.append(this.canvasTarget);
  }

  // To Download the Event QRCode
  download() {
    this.qrCode.download({
      name: `thepew-event-${this.shortCodeValue}`,
      extension: "svg",
    });
  }
}
