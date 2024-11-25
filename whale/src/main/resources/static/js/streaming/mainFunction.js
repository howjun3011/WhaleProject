// [ 리사이즈 함수 ]
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
        if (availableWidth > 200) {
            mainContentElement.style.width = `${availableWidth}px`;
        } else {
            mainContentElement.style.width = `200px`;
        }
    }
}


// [ 부모창으로부터 데이터 받는 함수 ]
window.addEventListener("message", receiveMessage, false);

// 데이터의 타입에 따라 각기 다른 창을 보여준다.
async function receiveMessage(event) {
    if (event.data.type === 'albumDetail') {
        window.location.href = '/whale/streaming/albumDetail?albumId='+event.data.albumId;
    } else if (event.data.type === 'trackDetail') {
        window.location.href = '/whale/streaming/detail?trackId='+event.data.trackId;
    } else if (event.data.type === 'artistDetail') {
        window.location.href = '/whale/streaming/artistDetail?artistId='+event.data.artistId;
    } else {
    }
}


// [ 라이브러리 확장 기능 ]
$(document).ready(function () {
    var isExpanded = false;

    $('#toggleButton').click(function () {
        isExpanded = !isExpanded;
        $('.mainLibraryFrame').toggleClass('expanded', isExpanded);

        const path = $('#toggleButton path');
        if (isExpanded) {
            path.attr('d', 'M3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zM15.5 2.134A1 1 0 0 0 14 3v18a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V6.464a1 1 0 0 0-.5-.866l-6-3.464zM9 2a1 1 0 0 0-1 1v18a1 1 0 1 0 2 0V3a1 1 0 0 0-1-1z'); // 확장 시 새로운 d 값
        } else {
            path.attr('d', 'M14.5 2.134a1 1 0 0 1 1 0l6 3.464a1 1 0 0 1 .5.866V21a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1V3a1 1 0 0 1 .5-.866zM16 4.732V20h4V7.041l-4-2.309zM3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zm6 0a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1z'); // 축소 시 기본 d 값
        }
    });
});


// [ 스크롤 이동 함수 ]
function updateScrollButtons(containerSelector) {
    const container = document.querySelector(containerSelector);
    if (!container) return;

    const scrollLeftBtn = container.parentNode.querySelector('.xButton.left');
    const scrollRightBtn = container.parentNode.querySelector('.xButton.right');

    if (container.scrollLeft > 0) {
        scrollLeftBtn.classList.remove('hidden');
    } else {
        scrollLeftBtn.classList.add('hidden');
    }

    const maxScrollLeft = container.scrollWidth - container.clientWidth;
    if (container.scrollLeft < maxScrollLeft) {
        scrollRightBtn.classList.remove('hidden');
    } else {
        scrollRightBtn.classList.add('hidden');
    }
}

function scrollContent(containerSelector, direction) {
    const container = document.querySelector(containerSelector);
    if (!container) return;
    
    const scrollAmount = direction === 'left' ? -210 : 210;
    container.scrollBy({ left: scrollAmount, behavior: 'smooth' });

    setTimeout(() => {
        updateScrollButtons(containerSelector);
    }, 300);
}

function checkScroll(containerSelector) {
    const container = document.querySelector(containerSelector);
    if (container) {
        updateScrollButtons(containerSelector);
        container.addEventListener('scroll', () => updateScrollButtons(containerSelector));
    }
}

// 스크롤 및 초기 버튼 상태 설정
document.addEventListener("DOMContentLoaded", () => {
	checkScroll('.x0');
	checkScroll('.x1');
	checkScroll('.x2');
	checkScroll('.x3');
});


// [ 길이에 따른 폰트 크기 조절 함수 ]
function adjustFontSizeByTextLength(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        const textLength = element.innerText.length;

        if (textLength > 16) {
            element.classList.add("small-font");
        } else if (textLength > 8) {
            element.classList.add("medium-font");
        } else {
            element.classList.add("large-font");
        }
    }
}

// 페이지 로드 시 폰트 크기 조절
document.addEventListener("DOMContentLoaded", function() {
    adjustFontSizeByTextLength("trackName");
    adjustFontSizeByTextLength("playlistName");
    adjustFontSizeByTextLength("artistName");
    adjustFontSizeByTextLength("likedTracksName");
});


// [ a 태그 제거 함수 ]
document.addEventListener("DOMContentLoaded", function() {
    const descriptionElement = document.querySelector(".playlistDesc");
    if (descriptionElement) {
        // a 태그를 찾아 제거
        const parser = new DOMParser();
        const parsedContent = parser.parseFromString(descriptionElement.innerHTML, 'text/html');
        const links = parsedContent.querySelectorAll("a");

        // 각 a 태그를 순회하며 텍스트만 남기기
        links.forEach(link => {
            const textNode = document.createTextNode(link.textContent);
            link.replaceWith(textNode);
        });

        // 수정된 내용을 다시 playlistDesc에 반영
        descriptionElement.innerHTML = parsedContent.body.innerHTML;
    }
});


// [ 재생 및 정지 기능 ]
// 1. 한곡 재생 및 정지 함수
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
                return Promise.resolve();
            } else {
                console.error("Failed to play track");
                return Promise.reject(new Error("Failed to play track"));
            }
        })
        .catch(error => {
            console.error("Error playing track:", error);
            return Promise.reject(error);
        });
}

function pauseTrack(trackId) {
    return fetch('/whale/streaming/pauseTrack', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ trackId: trackId })
    })
        .then(response => {
            if (response.ok) {
                console.log("Track is now paused");
                return Promise.resolve();
            } else {
                console.error("Failed to pause track");
                return Promise.reject(new Error("Failed to pause track"));
            }
        })
        .catch(error => {
            console.error("Error pausing track:", error);
            return Promise.reject(error);
        });
}

// 2. 한곡 재생/일시정지 상태를 토글하는 함수
function togglePlayPause(trackId, button) {
    const isPlaying = button.classList.contains("playing");

    if (isPlaying) {
        // 일시정지 호출
        pauseTrack(trackId)
            .then(() => {
                button.classList.remove("playing");
                button.querySelector(".icon").innerHTML = `
                        <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>`; // 재생 아이콘으로 변경
            })
            .catch(error => console.error("Error pausing track:", error));
    } else {
        // 재생 호출
        playTrack(trackId)
            .then(() => {
                button.classList.add("playing");
                button.querySelector(".icon").innerHTML = `
                        <path d="M6 19h4V5H6zm8-14v14h4V5z"></path>`; // 일시정지 아이콘으로 변경
            })
            .catch(error => console.error("Error playing track:", error));
    }
}

// 3. 플레이리스트 전체 재생 함수
function playAllPlaylist(playlistId) {
    return fetch('/whale/streaming/playAllPlaylist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ playlistId: playlistId })
    })
        .then(response => {
            if (response.ok) {
                console.log("Playlist is now playing");
            } else {
                console.error("Failed to play playlist");
            }
        })
        .catch(error => {
            console.error("Error playing playlist:", error);
        });
}

// 4. 앨범 전체 재생 함수
function playAllAlbum(albumId) {
    fetch('/whale/streaming/playAllAlbum', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({ albumId: albumId })
    })
        .then(response => response.json())
        .then(data => {
            if (data) {
                console.log("앨범 전체 재생 시작");
            } else {
                console.error("앨범 재생 실패");
            }
        })
        .catch(error => console.error("앨범 재생 요청 중 오류 발생:", error));
}

// 5. 좋아요 전체 트랙 재생 함수
function playAllLikeTrack(i) {
	fetch(`/whale/streaming/playAllLikeTrack`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ uris: i })
    });
}


// [ 리다이렉트 함수 ]
// 1. 스트리밍 홈 화면으로 리다이렉트
function goMain() {
    window.location.href = "/whale/streaming";
}

// 2. 트랙 디테일 페이지로 리다이렉트
function navigateToDetail(trackId) {
    window.location.href = `/whale/streaming/detail?trackId=${trackId}`;
}

// 3. 아티스트 디테일 페이지로 리다이렉트
function navigateToArtistDetail(artistId) {
    window.location.href = `/whale/streaming/artistDetail?artistId=${artistId}`;
}

// 4. 플레이리스트 디테일 페이지로 리다이렉트
function playPlaylist(playlistId) {
    window.location.href = `/whale/streaming/playlistDetail?playlistId=${playlistId}`;
}

// 5. 앨범 디테일 페이지로 리다이렉트
function navigateToAlbumDetail(albumId) {
    window.location.href = `/whale/streaming/albumDetail?albumId=${albumId}`;
}

// 6. 좋아요 디테일 페이지로 리다이렉트
function navigateToLikedTracks() {
    window.location.href = "/whale/streaming/likedTracks";
}

// 7. 스트리밍 서치 기능
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
        if (event.key === "Enter") {
            goSearch();
        }
    });
});


// [ 재생 및 리다이렉트 함수 ]
// 1. 재생 후 트랙 디테일 페이지로 리다이렉트
function playAndNavigate(trackId) {
    // 트랙을 재생하고 성공 시 navigateToDetail 호출
    playTrack(trackId).then(() => {
        navigateToDetail(trackId);
    }).catch(error => console.error("Error during play and navigate:", error));
}


// [ 좋아요 관련 함수 ]
// 좋아요 상태 변경 함수
let likeActionPending = false; // 중복 요청 방지를 위한 상태 잠금 변수

async function insertTrackLike(coverUrl, trackName, artistName, albumName, trackId, isLiked) {
    if (likeActionPending) return;
    likeActionPending = true;

    const trackInfo = [coverUrl, trackName, artistName, albumName, trackId, isLiked];

    try {
        const body = {
            artistName: trackInfo[2],
            trackName: trackInfo[1],
            albumName: trackInfo[3],
            trackCover: trackInfo[0],
            trackSpotifyId: trackInfo[4]
        };

        await fetch(`/whale/streaming/toggleTrackLike`, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'POST',
            body: JSON.stringify(body)
        });
    } catch (error) {
        console.error('Error while updating the Track Like Data:', error);
    } finally {
        likeActionPending = false;
    }
}

// 좋아요 토글에 따라 아이콘 변경 함수
function toggleIcon(element) {
    const svg = element.querySelector("svg");

	if (svg.style.fill === 'rgb(203, 130, 163)') {
		svg.style.fill = '#000000';
    } else {
		svg.style.fill = 'rgb(203, 130, 163)';
    }
}

// 해당 트랙의 좋아요 상태 확인 함수
async function checkTrackLikeStatus(trackId, trackElement) {
    try {
        const response = await fetch("/whale/streaming/checkTrackLike", {
            method: "POST",
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ trackSpotifyId: trackId })
        });

        const data = await response.json();
        // `recommendationLike`와 `recentlyPlayedTrackLike`에서 좋아요 아이콘을 찾아 변경
        let imgElement = trackElement.querySelector(".recommendationLike img")
            || trackElement.querySelector(".recentlyPlayedTrackLike img");

        if (data.result === "liked") {
            imgElement.src = `${window.contextPath}/static/images/streaming/liked.png`;
        } else {
            imgElement.src = `${window.contextPath}/static/images/streaming/like.png`;
        }
    } catch (error) {
    }
}

// 해당 트랙의 좋아요 상태 확인 함수: 트랙 디테일 페이지
async function checkTrackDetailLikeStatus(trackId, trackElement) {
    try {
        const response = await fetch("/whale/streaming/checkTrackLike", {
            method: "POST",
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ trackSpotifyId: trackId })
        });

        const data = await response.json();
        const iconElement = trackElement.querySelector(".icon"); // icon 요소 선택

        if (data.result === "liked") {
            iconElement.style.filter = "invert(0)";
        } else {
            iconElement.style.filter = "invert(1)";
        }
    } catch (error) {
        console.error("Error checking track like status:", error);
    }
}

// 페이지 로드 시 모든 트랙의 좋아요 상태 확인
document.addEventListener("DOMContentLoaded", function() {
    const trackElements = document.querySelectorAll("[data-track-id]"); // data-track-id 속성을 가진 모든 요소 선택

    trackElements.forEach(trackElement => {
        const trackId = trackElement.getAttribute("data-track-id"); // 트랙 ID 가져오기
        checkTrackLikeStatus(trackId, trackElement); // 트랙 ID와 요소를 전달하여 좋아요 상태 확인
    });
});

// 페이지 로드 시 트랙 디테일 페이지의 좋아요 상태 확인
document.addEventListener("DOMContentLoaded", function() {
    const trackDetailElement = document.querySelector(".trackDetailLike");

    if (trackDetailElement) {
        const trackId = trackDetailElement.getAttribute("data-track-id"); // trackDetailLike의 트랙 ID 가져오기
        checkTrackDetailLikeStatus(trackId, trackDetailElement); // 트랙 ID와 요소를 전달하여 좋아요 상태 확인
    }
});

// 스트리밍 메인 페이지의 좋아요 버튼 클릭 시 이미지 변경 함수
document.addEventListener("DOMContentLoaded", function() {
    // recommendationLike 및 recentlyPlayedTrackLike 클래스의 모든 이미지 요소 선택
    const likeButtons = document.querySelectorAll(".recommendationLike img, .recentlyPlayedTrackLike img");

    likeButtons.forEach(button => {
        button.addEventListener("click", function() {
            // 현재 이미지 경로 가져오기
            const currentSrc = button.src;

            // 이미지 경로 비교 후 변경
            if (currentSrc.includes("like.png")) {
                button.src = `${window.contextPath}/static/images/streaming/liked.png`;
            } else {
                button.src = `${window.contextPath}/static/images/streaming/like.png`;
            }
        });
    });
});

// 트랙 디테일 페이지의 좋아요 버튼 클릭 시 이미지 변경 함수
document.addEventListener("DOMContentLoaded", function() {
    // trackDetailLike 클래스의 모든 .icon 요소 선택
    const likeButtons = document.querySelectorAll(".trackDetailLike .icon");

    likeButtons.forEach(button => {
        button.addEventListener("click", function() {
            if (button.style.filter === "invert(1)") {
                button.style.filter = "invert(0)";
            } else {
                button.style.filter = "invert(1)";
            }
        });
    });
});


// [ 플레이리스트 추가 및 삭제 함수 ]
function followPlaylist(i,j) {
    if (i === 0) {
        fetch(`/whale/streaming/followPlaylist?id=${ j }`);
    } else {
        fetch(`/whale/streaming/unfollowPlaylist?id=${ j }`);
    }
    setTimeout(() => {location.href = '/whale/streaming/playlistDetail?playlistId='+j;},500);
}


// [ 트랙 아이디 복사 함수: 트랙 디테일 페이지 ]
function copyTrackId(a,b,c,d,e) {
    // 해당 트랙 Whale DB에 저장
    const body = {
        artistName: c,
        trackName: b,
        albumName: d,
        trackCover: a,
        trackSpotifyId: e
    };

    fetch(`/whale/streaming/insertTrackInfo`, {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method: 'POST',
        body: JSON.stringify(body)
    });
    // 클립 보드 카피 기능
    var t = document.createElement("textarea");
    document.body.appendChild(t);
    t.value = `%music%${e}`;
    t.select();
    document.execCommand('copy');
    document.body.removeChild(t);
    alert('해당 트랙 아이디를 복사했습니다.');
}
