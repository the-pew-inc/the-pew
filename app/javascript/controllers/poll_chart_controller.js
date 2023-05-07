import { Controller } from "@hotwired/stimulus";
import Chart from "chart.js/auto";

// Connects to data-controller="poll-chart"
export default class extends Controller {
  static targets = ["chart"];
  static values = {
    labels: Array,
    data: Array,
  };

  connect() {
    // Set up the chart
    this.chart = new Chart(this.chartTarget, {
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            backgroundColor: "rgba(79, 70, 229, 1)",
            data: this.dataValue,
          },
        ],
      },
      options: {
        indexAxis: "y", // To have horizontal bars
        plugins: {
          legend: {
            display: false,
          },
        },
        title: {
          display: false,
          text: "Predicted world population (millions) in 2050",
        },
        responsive: true,
      },
    });
  }

  // Used to update the chart
  // Add new data to the chart
  addData(chart, label, data) {
    chart.data.labels.push(label);
    chart.data.datasets.forEach((dataset) => {
      dataset.data.push(data);
    });
    chart.update();
  }

  // Remove data from the chart
  removeData(chart) {
    chart.data.labels.pop();
    chart.data.datasets.forEach((dataset) => {
      dataset.data.pop();
    });
    chart.update();
  }
}
