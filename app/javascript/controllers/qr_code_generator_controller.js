import { Controller } from "@hotwired/stimulus";
import QRCodeStyling from "qr-code-styling";

// Connects to data-controller="qr-code-generator"
// Description: Used to generate EVENT QR Code on the fly (aka client side)
export default class extends Controller {
  static targets = ["canvas"];
  static values = {
    shortCode: String,
    size: { type: Number, default: 680 },
    logoURL: String,
  };

  connect() {
    // Get the server URL
    let serverUrl = window.location.origin;

    // Check if the server URL has a trailing slash
    if (!serverUrl.endsWith("/")) {
      // Remove the trailing slash
      serverUrl = serverUrl.replace(/\/$/, "");
    }

    // QR Code params
    let qrCodeParams = {
      width: this.sizeValue,
      height: this.sizeValue,
      type: "svg",
      data: `${serverUrl}/event/${this.shortCodeValue}?source=from_qr`,
      dotsOptions: {
        color: "#4267b2",
        type: "rounded",
      },
      backgroundOptions: {
        color: "transparent",
      },
      imageOptions: {
        crossOrigin: "anonymous",
        margin: 20,
      },
    };

    // Generate the QRCode and attached it to the target
    this.qrCode = new QRCodeStyling(qrCodeParams);

    this.qrCode.append(this.canvasTarget);
  }

  download() {
    this.qrCode.download({ name: "qr", extension: "svg" });
  }
}
