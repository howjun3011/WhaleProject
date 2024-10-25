/**
 * 메세지 검색 화면
 */
$(document).ready(function() {
	$(".tab").on("click", function() {
		var tabId = $(this).data("tab"); // 클릭된 탭의 data-tab 값 가져오기

		// 현재 탭 비활성화 및 내용 숨기기
		$(".tab.now").removeClass("now");
		// 클릭된 탭 활성화
		$(this).addClass("now");

		// AJAX 호출로 JSP 화면 불러오기
		$.ajax({
			url: 'search', // AJAX 요청을 보낼 URL
			method: 'POST',
			data: { tabId: tabId }, // 필요한 데이터 (예: 어떤 탭인지)
			success: function(data) {
				$('#result').html(data); // 받아온 데이터를 #content에 삽입
				//체크박스 선택 시 버튼 나타남
				updateConfirmBtn();
			},
			error: function() {
				console.log('에러가 발생했습니다.');
			}
		});


	});

	function updateConfirmBtn() {
		//체크 상태에 따른 버튼 상태 변화
		//유저 검색 체크박스
		const checkboxes = document.querySelectorAll('.box');
		const confirmButton = document.getElementById('confirmButton');
		checkboxes.forEach(function(checkbox) {
			checkbox.addEventListener('change', function() {
				const checkedCount = Array.from(checkboxes).filter(x => x.checked).length;
				confirmButton.style.display = checkedCount > 0 ? 'block' : 'none'; // 하나 이상 선택되면 버튼 표시
			});

		});
		// 초기 버튼 상태 업데이트
		const initialCheckedCount = Array.from(checkboxes).filter(x => x.checked).length;
		confirmButton.style.display = initialCheckedCount > 0 ? 'block' : 'none';
	}

	// 유저 목록 확인 버튼 클릭 이벤트 리스너
	function handleConfirm() {

		// 체크된 체크박스 목록 가져오기
		var checkboxes = document.querySelectorAll('.box:checked'); //선택된 체크박스 가져오기
		var selectedIds = Array.from(checkboxes).map(x => x.dataset.id); // 선택된 체크박스의 data-id 속성 값을 배열로 저장
		var tabId = $('.tab.now').data("tab");
		// AJAX 요청으로 선택된 ID 송부
		$.ajax({
			url: 'search',
			method: 'POST',
			data: { selectedIds: selectedIds, tabId: tabId }, // 선택된 ID 배열
			traditional: true, // 배열을 전송할 때 필요. 이 옵션을 설정하면, 배열의 요소가 일반적인 쿼리 문자열 형식으로 전송
			success: function(response) {
				// 요청 성공 시 처리
				$('#result').html(response); // 받아온 데이터를 #result에 삽입
			},
			error: function() {
				console.log('에러가 발생했습니다.');
			}
		});
	};

});

