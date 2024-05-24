
//Chart
var color1 = "#00a86b";
var xValues = [50,60,70,80,90,100,110,120,130,140,150];
var yValues = [7,8,8,9,9,9,10,11,14,14,15];
//charts temperature
new Chart("chtemptop", {
  type: "line",
  data: {
    labels: xValues,
    datasets: [{
      fill: false,
      lineTension: 0,
      backgroundColor: color1,
      borderColor: color1,
      data: yValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
        display: true,
        text: "Temperature top"
    },
    scales: {
      yAxes: [{ticks: {min: 6, max:16}}],
    }
  }
});
new Chart("chtempcenter", {
    type: "line",
    data: {
      labels: xValues,
      datasets: [{
        fill: false,
        lineTension: 0,
        backgroundColor: color1,
        borderColor: color1,
        data: yValues
      }]
    },
    options: {
      legend: {display: false},
      title: {
          display: true,
          text: "Temperature center"
        },
      scales: {
        yAxes: [{ticks: {min: 6, max:16}}],
      }
    }
  });
  new Chart("chtempbottom", {
    type: "line",
    data: {
      labels: xValues,
      datasets: [{
        fill: false,
        lineTension: 0,
        backgroundColor: color1,
        borderColor: color1,
        data: yValues
      }]
    },
    options: {
      legend: {display: false},
      title: {
         display: true,
         text: "Temperature bottom"
        },
      scales: {
        yAxes: [{ticks: {min: 6, max:16}}],
      }
    }
  });
//charts temperature end

  new Chart("chlight", {
    type: "line",
    data: {
      labels: xValues,
      datasets: [{
        fill: false,
        lineTension: 0,
        backgroundColor: color1,
        borderColor: color1,
        data: yValues
      }]
    },
    options: {
      legend: {display: false},
      title: {
          display: true,
          text: "Light"
      },
      scales: {
        yAxes: [{ticks: {min: 6, max:16}}],
      }
    }
  });
  new Chart("chfans", {
      type: "line",
      data: {
        labels: xValues,
        datasets: [{
          fill: false,
          lineTension: 0,
          backgroundColor: color1,
          borderColor: color1,
          data: yValues
        }]
      },
      options: {
        legend: {display: false},
        title: {
            display: true,
            text: "Fans"
          },
        scales: {
          yAxes: [{ticks: {min: 6, max:16}}],
        }
      }
    });
    new Chart("chheating", {
      type: "line",
      data: {
        labels: xValues,
        datasets: [{
          fill: false,
          lineTension: 0,
          backgroundColor: color1,
          borderColor: color1,
          data: yValues
        }]
      },
      options: {
        legend: {display: false},
        title: {
           display: true,
           text: "Heating"
          },
        scales: {
          yAxes: [{ticks: {min: 6, max:16}}],
        }
      }
    });
    new Chart("chpump", {
        type: "line",
        data: {
          labels: xValues,
          datasets: [{
            fill: false,
            lineTension: 0,
            backgroundColor: color1,
            borderColor: color1,
            data: yValues
          }]
        },
        options: {
          legend: {display: false},
          title: {
             display: true,
             text: "Pump"
            },
          scales: {
            yAxes: [{ticks: {min: 6, max:16}}],
          }
        }
      });