<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
  // 데이터 설정
  const labels = ['January', 'February', 'March', 'April', 'May', 'June', 'July'];
  const data = {
    labels: labels,
    datasets: [
      {
        label: 'Dataset 1',
        data: [10, 20, 30, 40, 50, 60, 70], // 임의의 데이터
        borderColor: 'rgba(255, 99, 132, 1)',
        backgroundColor: 'rgba(255, 99, 132, 0.5)',
      },
      {
        label: 'Dataset 2',
        data: [20, 30, 40, 50, 60, 70, 80], // 임의의 데이터
        borderColor: 'rgba(54, 162, 235, 1)',
        backgroundColor: 'rgba(54, 162, 235, 0.5)',
      }
    ]
  };

  // 차트 설정
  const config = {
    type: 'bar',
    data: data,
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: 'top',
        },
        title: {
          display: true,
          text: 'Chart.js Bar Chart'
        }
      }
    }
  };

  // 차트 생성
  const myChart = new Chart(
    document.getElementById('myChart'),
    config
  );
</script>
<script>
  function addDataset() {
    const newDataset = {
      label: `Dataset ${data.datasets.length + 1}`,
      backgroundColor: 'rgba(75, 192, 192, 0.5)',
      borderColor: 'rgba(75, 192, 192, 1)',
      data: Array.from({ length: labels.length }, () => Math.floor(Math.random() * 100) - 50),
    };
    data.datasets.push(newDataset);
    myChart.update();
  }

  function removeDataset() {
    data.datasets.pop();
    myChart.update();
  }

  function addData() {
    const newLabel = `Month ${labels.length + 1}`;
    labels.push(newLabel);
    data.datasets.forEach(dataset => {
      dataset.data.push(Math.floor(Math.random() * 100) - 50);
    });
    myChart.update();
  }

  function removeData() {
    labels.pop();
    data.datasets.forEach(dataset => {
      dataset.data.pop();
    });
    myChart.update();
  }

  function randomizeData() {
    data.datasets.forEach(dataset => {
      dataset.data = dataset.data.map(() => Math.floor(Math.random() * 100) - 50);
    });
    myChart.update();
  }
</script>


<div class="content" name="content" id="content">
	<canvas id="userChart"></canvas>
	<button onclick="addDataset()">Add Dataset</button>
<button onclick="removeDataset()">Remove Dataset</button>
<button onclick="addData()">Add Data</button>
<button onclick="removeData()">Remove Data</button>
<button onclick="randomizeData()">Randomize Data</button>
</div>