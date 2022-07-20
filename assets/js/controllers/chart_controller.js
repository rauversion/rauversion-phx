
import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto';

export default class extends Controller {

  connect(){

    const labels = ["January", "February", "March", "April", "May", "June"];
    const data = {
      labels: labels,
      datasets: [
        {
          label: "My First dataset",
          backgroundColor: "hsl(252, 82.9%, 67.8%)",
          borderColor: "hsl(252, 82.9%, 67.8%)",
          data: [0, 10, 5, 2, 20, 30, 45],
        },
      ],
    };

    const configLineChart = {
      type: "bar",
      data,
      options: {},
    };

    var chartLine = new Chart(
      document.getElementById("chartLine"),
      configLineChart
    );

  }
}

    