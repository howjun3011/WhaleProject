// [ Resize ]
$(document).ready(() => {
    resize();
});
$(window).resize(() => {
    resize();
});

function resize() {
    const libraryElement = document.querySelector(".mainLibraryFrame");
    const detailElement = document.querySelector(".mainDetailFrame");
    const headerElement = document.querySelector(".header");
    const footerElement = document.querySelector(".footer");
    const mainElement = document.querySelector('.main');
    const mainContentElement = document.querySelector('.mainContentFrame');

    const windowWidth = window.innerWidth;
    const libraryWidth = libraryElement ? libraryElement.offsetWidth : 0;
    const detailWidth = detailElement ? detailElement.offsetWidth : 0;

    const windowHeight = window.innerHeight;
    const headerHeight = headerElement ? headerElement.offsetHeight : 0;
    const footerHeight = footerElement ? footerElement.offsetHeight : 0;

    if (mainElement) {
        mainElement.style.height = `${windowHeight - headerHeight - footerHeight}px`;
    }

    if (mainContentElement) {
        const availableWidth = windowWidth - libraryWidth - detailWidth;
        if (availableWidth > 200) { // Ensure minimum space for mainContentFrame
            mainContentElement.style.width = `${availableWidth}px`;
        } else {
            mainContentElement.style.width = `200px`; // Assign minimum width to avoid collapsing
        }
    }
}


// [ Get the Data from the Parent Window ]
window.addEventListener("message", receiveMessage, false);

async function receiveMessage(event) {
    if (event.data === 'Full') {
        console.log(event.data);
    } else {
        await sendDeviceId(event);
    }
}

async function sendDeviceId(event) {
    sessionStorage.device_id = event.data;

    const body = {
        device_id: sessionStorage.device_id,
    };
    fetch(`/whale/streaming/getDeviceId`, {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method: 'POST',
        body: JSON.stringify(body)
    })
        .then((response) => response.json())
        .then((data) => {
            sessionStorage.accessToken = data.accessToken;
            console.log("Success fetching device id to the Node js Wep App");
        })
        .catch((error) => console.error("Failed to fetch the device_id: ", error));
}

function playTrack(trackId) {
    return fetch('/whale/streaming/playTrack', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ trackId: trackId })
    })
        .then(response => {
            if (response.ok) {
                console.log("Track is now playing");
                return Promise.resolve(); // 성공 시 Promise 반환
            } else {
                console.error("Failed to play track");
                return Promise.reject(new Error("Failed to play track")); // 실패 시 에러 반환
            }
        })
        .catch(error => {
            console.error("Error playing track:", error);
            return Promise.reject(error);
        });
}

function playAndNavigate(trackId) {
    // 트랙을 재생하고 성공 시 navigateToDetail 호출
    playTrack(trackId).then(() => {
        navigateToDetail(trackId);
    }).catch(error => console.error("Error during play and navigate:", error));
}


$(document).ready(function () {
    var isExpanded = false;

    $('#toggleButton').click(function () {
        isExpanded = !isExpanded; // 상태를 토글
        $('.mainLibraryFrame, .mainLibrary').toggleClass('expanded', isExpanded); // 두 요소에 클래스 추가/제거
    });
});

// 스크롤 이동 함수
function updateScrollButtons() {
    const container = document.getElementById('recommendationContents');
    const scrollLeftBtn = document.getElementById('scrollLeftBtn');
    const scrollRightBtn = document.getElementById('scrollRightBtn');

    // 왼쪽 버튼 보이기/숨기기
    if (container.scrollLeft > 0) {
        scrollLeftBtn.classList.remove('hidden');
    } else {
        scrollLeftBtn.classList.add('hidden');
    }

    // 오른쪽 버튼 보이기/숨기기
    const maxScrollLeft = container.scrollWidth - container.clientWidth;
    if (container.scrollLeft < maxScrollLeft) {
        scrollRightBtn.classList.remove('hidden');
    } else {
        scrollRightBtn.classList.add('hidden');
    }
}

function scrollLeftContent() {
    const container = document.getElementById('recommendationContents');
    container.scrollBy({ left: -210, behavior: 'smooth' });
    setTimeout(updateScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

function scrollRightContent() {
    const container = document.getElementById('recommendationContents');
    container.scrollBy({ left: 210, behavior: 'smooth' });
    setTimeout(updateScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

// 스크롤 및 초기 버튼 상태 설정
document.addEventListener("DOMContentLoaded", () => {
    updateScrollButtons(); // 초기 상태
    const container = document.getElementById('recommendationContents');
    container.addEventListener('scroll', updateScrollButtons); // 스크롤 이벤트 감지
});

// 트랙 이미지 누르면 트랙 디테일 페이지로 리다이렉트
function navigateToDetail(trackId) {
    window.location.href = `/whale/streaming/detail?trackId=${trackId}`;
}

document.addEventListener("DOMContentLoaded", function() {
    const trackNameElement = document.getElementById("trackName");
    const textLength = trackNameElement.innerText.length;

    if (textLength > 16) {
        trackNameElement.classList.add("small-font");
    } else if (textLength > 8) {
        trackNameElement.classList.add("medium-font");
    } else {
        trackNameElement.classList.add("large-font");
    }
});

// 스트리밍 홈 화면으로 돌아가는 버튼
function goMain() {
    window.location.href = "/whale/streaming";
}

// 스트리밍 서치 기능
function goSearch() {
    window.location.href = "/whale/streaming/search";
    const query = document.querySelector('.headerInput').value;
    if (query) {
        window.location.href = `/whale/streaming/search?query=${encodeURIComponent(query)}`;
    } else {
        alert("검색어를 입력해주세요.");
        window.location.href = `/whale/streaming`;
    }
}

// 엔터 키 입력 시 검색 실행
document.addEventListener("DOMContentLoaded", () => {
    const headerInput = document.querySelector('.headerInput');

    headerInput.addEventListener("keypress", (event) => {
        if (event.key === "Enter") {  // Enter 키 확인
            goSearch();
        }
    });
});


// 검색 결과 스크롤 이동 함수
function updateSearchScrollButtons() {
    const container = document.querySelector('.searchResults');
    const searchScrollLeftBtn = document.getElementById('searchScrollLeftBtn');
    const searchScrollRightBtn = document.getElementById('searchScrollRightBtn');

    // 왼쪽 버튼 보이기/숨기기
    if (container.scrollLeft > 0) {
        searchScrollLeftBtn.classList.remove('hidden');
    } else {
        searchScrollLeftBtn.classList.add('hidden');
    }

    // 오른쪽 버튼 보이기/숨기기
    const maxScrollLeft = container.scrollWidth - container.clientWidth;
    if (container.scrollLeft < maxScrollLeft - 1) { // 약간의 여유를 두어 숨김 처리
        searchScrollRightBtn.classList.remove('hidden');
    } else {
        searchScrollRightBtn.classList.add('hidden');
    }
}

function scrollLeftSearchContent() {
    const container = document.querySelector('.searchResults');
    container.scrollBy({ left: -210, behavior: 'smooth' });
    setTimeout(updateSearchScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

function scrollRightSearchContent() {
    const container = document.querySelector('.searchResults');
    container.scrollBy({ left: 210, behavior: 'smooth' });
    setTimeout(updateSearchScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

// 스크롤 및 초기 버튼 상태 설정
document.addEventListener("DOMContentLoaded", () => {
    updateSearchScrollButtons(); // 초기 상태
    const container = document.querySelector('.searchResults');
    container.addEventListener('scroll', updateSearchScrollButtons); // 스크롤 이벤트 감지
});

