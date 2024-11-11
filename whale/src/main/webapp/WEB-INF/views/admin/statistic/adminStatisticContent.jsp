<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- Chart.js와 Bootstrap을 외부에서 가져오기 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"> -->
<div class="content" name="content" id="content">
	<div class="container">
		<h1>신고</h1>
	    <div class="chartBox">
	        <canvas id="reportChart"></canvas>
	    </div>
	    <div class="btnBox">
		    <button id="btnChart1">통계1</button>
		    <button id="btnChart2">통계2</button>
		    <button id="btnChart3">통계3</button>
		    <button id="btnChart4">통계4</button>
	    </div>
	</div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
    	
    	var labels = [];
    	<c:forEach var="label" items="${labels}">
    	    labels.push('${label}');
    	</c:forEach>
    	
    	var values = [];
    	<c:forEach var="value" items="${values}">
    	    values.push(${value});
    	</c:forEach>
    	
        const ctx = document.getElementById('reportChart').getContext('2d');
        let chartData = {
                labels: ['월', '화', '수', '목', '금', '토', '일'],
                datasets: [{
                    label: '방문자 수',
                    data: [120, 190, 30, 50, 20, 30, 70],
                    backgroundColor: 'rgba(54, 162, 235, 0.5)'
                }]
            };

            // 차트 생성
            let myChart = new Chart(ctx, {
                type: 'bar',
                data: chartData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });

            // 버튼 클릭 이벤트 핸들러
            document.getElementById('btnChart1').addEventListener('click', function () {
                updateChart('bar', ['월', '화', '수', '목', '금', '토', '일'], [120, 190, 30, 50, 20, 30, 70], '방문자 수');
            });

            document.getElementById('btnChart2').addEventListener('click', function () {
                updateChart('line', ['1분기', '2분기', '3분기', '4분기'], [200, 300, 400, 500], '매출액');
            });

            document.getElementById('btnChart3').addEventListener('click', function () {
                updateChart('pie', ['Chrome', 'Safari', 'Firefox', 'IE'], [55, 25, 15, 5], '브라우저 점유율');
            });

            document.getElementById('btnChart4').addEventListener('click', function () {
                updateChart('radar', ['속도', '신뢰성', '디자인', '사용성'], [80, 90, 70, 85], '제품 평가');
            });

            // 차트를 업데이트하는 함수
            function updateChart(type, labels, data, label) {
                myChart.destroy(); // 기존 차트 삭제
                myChart = new Chart(ctx, {
                    type: type,
                    data: {
                        labels: labels,
                        datasets: [{
                            label: label,
                            data: data,
                            backgroundColor: getBackgroundColors(data.length),
                            borderColor: getBorderColors(data.length),
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
            }

            // 배경색 생성 함수
            function getBackgroundColors(length) {
                const colors = [
                    'rgba(255, 99, 132, 0.5)',
                    'rgba(54, 162, 235, 0.5)',
                    'rgba(255, 206, 86, 0.5)',
                    'rgba(75, 192, 192, 0.5)',
                    'rgba(153, 102, 255, 0.5)',
                    'rgba(255, 159, 64, 0.5)',
                    'rgba(201, 203, 207, 0.5)'
                ];
                return colors.slice(0, length);
            }

            // 테두리색 생성 함수
            function getBorderColors(length) {
                const colors = [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                    'rgba(201, 203, 207, 1)'
                ];
                return colors.slice(0, length);
            }
        });
</script>
