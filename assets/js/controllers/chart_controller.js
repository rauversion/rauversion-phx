
import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto';

export default class extends Controller {

  static values = {
    points: Array,
    label: String
  }

  connect(){
    const labels = this.pointsValue.map((s)=> s.day );
    const data = {
      labels: labels,
      datasets: [
        {
          label: this.labelValue,
          backgroundColor: "hsl(252, 82.9%, 67.8%)",
          borderColor: "hsl(252, 82.9%, 67.8%)",
          data: this.pointsValue.map((s)=> s.count ),
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

    