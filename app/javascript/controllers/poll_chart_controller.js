import { Controller } from "@hotwired/stimulus";
import Chart from "chart.js/auto";
import ChartDataLabels from "chartjs-plugin-datalabels";

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
      plugins: [ChartDataLabels],
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            backgroundColor: "rgba(79, 70, 229, 1)",
            data: this.dataValue,
            borderWidth: 0,
            barPercentage: 1,
            categoryPercentage: 0.5,
          },
        ],
      },
      options: {
        indexAxis: "y", // To have horizontal bars
        scales: {
          x: {
            grid: {
              display: false,
            },
          },
        },
        plugins: {
          legend: {
            display: false,
          },
          datalabels: {
            display: true,
            align: "start",
            anchor: "start",
            offset: 5,
            color: "#000", // Choose the color you want for the labels
            // formatter: function (value, context) {
            //   return value; // Display the data value as-is
            // },
          },
        },
        title: {
          display: false,
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
