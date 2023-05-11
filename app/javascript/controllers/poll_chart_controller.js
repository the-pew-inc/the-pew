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
    // Create the chart and displays it
    this.chart = new Chart(this.chartTarget, {
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            backgroundColor: "rgba(79, 70, 229, 0.4)",
            borderColor: "rgba(79, 70, 229, 1)",
            data: this.dataValue,
            borderWidth: 1,
            borderSkipped: false,
            borderRadius: 5,
            barPercentage: 1,
            categoryPercentage: 0.5,
          },
        ],
      },
      plugins: [ChartDataLabels],
      options: {
        events: [],
        indexAxis: "y", // To have horizontal bars
        scales: {
          x: {
            grid: {
              display: false,
              drawBorder: false,
            },
            ticks: { display: false },
          },
          y: {
            grid: {
              display: false,
              drawBorder: false,
            },
            ticks: { display: false },
          },
        },
        plugins: {
          legend: { display: false },
          tooltip: { enabled: false },
          hover: { mode: null },
        },
        title: { display: false },
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
