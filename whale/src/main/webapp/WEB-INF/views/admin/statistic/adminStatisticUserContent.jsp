<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- Chart.js와 Bootstrap을 외부에서 가져오기 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"> -->
<div class="content" name="content" id="content">
	<div class="container">
		<h1 id="statistic-name">추세</h1>
	    <div class="chartBox">
	        <canvas id="reportChart"></canvas>
	    </div>
	    <div class="btnBox">
		    <!-- <button id="btnChart1">추세</button>
		    <button id="btnChart2">일별 추이</button>
		    <button id="btnChart3">신고처리속도</button> -->
	    </div>
	</div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
    	
    	var userLabels1 = [];
    	<c:forEach var="label" items="${userLabels1}">
    	userLabels1.push('${label}');
    	</c:forEach>
    	var userValues1 = [];
    	<c:forEach var="value" items="${userValues1}">
    	userValues1.push(${value});
    	</c:forEach>
    	
    	
    	var userLabels2 = [];
    	<c:forEach var="label" items="${userLabels2}">
    	userLabels2.push('${label}');
    	</c:forEach>
    	var userValues2 = [];
    	<c:forEach var="value" items="${userValues2}">
    	userValues2.push(${value});
    	</c:forEach>
    	
    	
    	var userLabels3 = [];
    	<c:forEach var="label" items="${userLabels3}">
    	userLabels3.push('${label}');
    	</c:forEach>
    	var userValues3 = [];
    	<c:forEach var="value" items="${userValues3}">
    	userValues3.push(${value});
    	</c:forEach>
    	
    	var targetTypes = [];
        var actionCounts = [];
        var resultActions = [];
        <c:forEach var="value" items="${action_count}">
        targetTypes.push(${value});
    	</c:forEach>
        <c:forEach var="value" items="${actionCounts}">
        actionCounts.push(${value});
    	</c:forEach>
        <c:forEach var="value" items="${resultActions}">
        resultActions.push(${value});
    	</c:forEach>
        
        
        
        const ctx = document.getElementById('reportChart').getContext('2d');
        let chartData = {
                labels: userLabels1,
                datasets: [{
                    label: '유저수',
                    data: userValues1,
                    backgroundColor: 'rgba(162, 162, 235, 0.5)'
                }]
            };

            // 차트 생성
            let myChart = new Chart(ctx, {
                type: 'line',
                data: chartData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
    		            x: {
    		                grid: {
    		                    display: false
    		                }
    		            },
    		            y: {
    		                grid: {
    		                    display: true
    		                }
    		            }
    		        }
                }
            });

            // 버튼 클릭 이벤트 핸들러
            document.getElementById('btnChart1').addEventListener('click', function () {
                updateChart1('line', userLabels1, userValues1, '유저수');
                document.getElementById('statistic-name').innerText ="추세";
            });

            document.getElementById('btnChart2').addEventListener('click', function () {
                updateChart1('line', userLabels2, userValues2, '신고건');
                document.getElementById('statistic-name').innerText ="일별 추이";
            });

            document.getElementById('btnChart3').addEventListener('click', function () {
                updateChart2('pie', userLabels3, userValues3, '완료건');
                document.getElementById('statistic-name').innerText ="신고처리속도";
            });

            document.getElementById('btnChart4').addEventListener('click', function () {
                updateChart2('radar', ['속도', '신뢰성', '디자인', '사용성'], [80, 90, 70, 85], '신고건');
            });

            // 차트를 업데이트하는 함수
            function updateChart1(type, labels, data, label) {
                myChart.destroy(); // 기존 차트 삭제
                myChart = new Chart(ctx, {
                    type: type,
                    data: {
                        labels: labels,
                        datasets: [{
                            label: label,
                            data: data,
                            backgroundColor: 'rgba(162, 162, 235, 0.5)',
                            /* borderColor: getBorderColors(data.length), */
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
        		            x: {
        		                grid: {
        		                    display: false
        		                }
        		            },
        		            y: {
        		                grid: {
        		                    display: true
        		                }
        		            }
        		        }
                    }
                });
            }
            function updateChart2(type, labels, data, label) {
                myChart.destroy(); // 기존 차트 삭제
                myChart = new Chart(ctx, {
                    type: type,
                    data: {
                        labels: labels,
                        datasets: [{
                            label: label,
                            data: data,
                            backgroundColor: [
                            	'rgba(162, 162, 235, 0.5)',
                            	'rgba(120, 120, 235, 0.5)',
                            	'rgba(80, 80, 235, 0.5)'],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
        		            x: {
        		                grid: {
        		                    display: false
        		                }
        		            },
        		            y: {
        		                grid: {
        		                    display: true
        		                }
        		            }
        		        }
                    }
                });
            }
        });
</script>
