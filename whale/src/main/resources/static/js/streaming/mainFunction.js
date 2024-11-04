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


// [ 부모창으로부터 데이터 받는 함수 ]
window.addEventListener("message", receiveMessage, false);

async function receiveMessage(event) {
    if (event.data.type === 'albumDetail') {
        window.location.href = '/whale/streaming/albumDetail?albumId='+event.data.albumId;
    } else if (event.data.type === 'trackDetail') {
        window.location.href = '/whale/streaming/detail?trackId='+event.data.trackId;
    } else if (event.data.type === 'artistDetail') {
        window.location.href = '/whale/streaming/artistDetail?artistId='+event.data.artistId;
    } else {
        await sendDeviceId(event);
    }
}

async function sendDeviceId(event) {
    sessionStorage.device_id = event.data;

    const body = {
        device_id: sessionStorage.device_id,
    };
    fetch(`/whale/main/device_id`, {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method: 'POST',
        body: JSON.stringify(body)
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
                return Promise.resolve(); // 성공 시 Promise 반환
            } else {
                console.error("Failed to pause track");
                return Promise.reject(new Error("Failed to pause track")); // 실패 시 에러 반환
            }
        })
        .catch(error => {
            console.error("Error pausing track:", error);
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
        $('.mainLibraryFrame').toggleClass('expanded', isExpanded); // 메인 라이브러리 프레임 요소에 클래스 추가/제거

        // SVG 아이콘 변경
        const path = $('#toggleButton path');
        if (isExpanded) {
            path.attr('d', 'M3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zM15.5 2.134A1 1 0 0 0 14 3v18a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V6.464a1 1 0 0 0-.5-.866l-6-3.464zM9 2a1 1 0 0 0-1 1v18a1 1 0 1 0 2 0V3a1 1 0 0 0-1-1z'); // 확장 시 새로운 d 값
        } else {
            path.attr('d', 'M14.5 2.134a1 1 0 0 1 1 0l6 3.464a1 1 0 0 1 .5.866V21a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1V3a1 1 0 0 1 .5-.866zM16 4.732V20h4V7.041l-4-2.309zM3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zm6 0a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1z'); // 축소 시 기본 d 값
        }
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
	// 홈화면 기능시 함수 실행
	if (window.location.pathname === '/whale/streaming/home') {
		updateScrollButtons(); // 초기 상태
	    const container = document.getElementById('recommendationContents');
	    container.addEventListener('scroll', updateScrollButtons); // 스크롤 이벤트 감지
	}
});

// 트랙 이미지 누르면 트랙 디테일 페이지로 리다이렉트
function navigateToDetail(trackId) {
    window.location.href = `/whale/streaming/detail?trackId=${trackId}`;
}

// 길이에 따른 폰트 크기 조절 함수
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
});

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
	// 검색 기능시 함수 실행
	if (window.location.pathname === '/whale/streaming/search') {
		updateSearchScrollButtons(); // 초기 상태
	    const container = document.querySelector('.searchResults');
	    container.addEventListener('scroll', updateSearchScrollButtons); // 스크롤 이벤트 감지
	}
});

// 아티스트 디테일 스크롤 이동 함수
function updateArtistDetailScrollButtons() {
    const container = document.querySelector('.albumsWrap');
    const scrollLeftBtn = document.getElementById('artistDetailScrollLeftBtn');
    const scrollRightBtn = document.getElementById('artistDetailScrollRightBtn');

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

function scrollLeftArtistDetailContent() {
    const container = document.querySelector('.albumsWrap');
    container.scrollBy({ left: -210, behavior: 'smooth' });
    setTimeout(updateArtistDetailScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

function scrollRightArtistDetailContent() {
    const container = document.querySelector('.albumsWrap');
    container.scrollBy({ left: 210, behavior: 'smooth' });
    setTimeout(updateArtistDetailScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

// 아티스트 디테일 스크롤 초기화
document.addEventListener("DOMContentLoaded", () => {
	// 아티스트 디테일 기능시 함수 실행
	if (window.location.pathname === '/whale/streaming/artistDetail') {
		updateArtistDetailScrollButtons();
	    const container = document.querySelector('.albumsWrap');
	    container.addEventListener('scroll', updateArtistDetailScrollButtons); // 스크롤 이벤트 감지
	}
});

// 아티스트 디테일
function navigateToArtistDetail(artistId) {
    window.location.href = `/whale/streaming/artistDetail?artistId=${artistId}`;
}

// 플레이리스트 스크롤 이동 함수
function updatePlayListScrollButtons() {
    const container = document.querySelector('.relatedPlaylists');
    const scrollLeftBtn = document.getElementById('playListScrollLeftBtn');
    const scrollRightBtn = document.getElementById('playListScrollRightBtn');

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

function scrollLeftPlayListContent() {
    const container = document.querySelector('.relatedPlaylists');
    container.scrollBy({ left: -210, behavior: 'smooth' });
    setTimeout(updatePlayListScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

function scrollRightPlayListContent() {
    const container = document.querySelector('.relatedPlaylists');
    container.scrollBy({ left: 210, behavior: 'smooth' });
    setTimeout(updatePlayListScrollButtons, 300); // 스크롤 후 버튼 업데이트
}

// 플레이리스트 스크롤 초기화
document.addEventListener("DOMContentLoaded", () => {
	// 아티스트 디테일 기능시 함수 실행
	if (window.location.pathname === '/whale/streaming/artistDetail') {
		updatePlayListScrollButtons();
	    const container = document.querySelector('.relatedPlaylists');
	    container.addEventListener('scroll', updatePlayListScrollButtons); // 스크롤 이벤트 감지
	}
});

// 재생/일시정지 상태를 토글하는 함수
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

function playPlaylist(playlistId) {
    window.location.href = `/whale/streaming/playlistDetail?playlistId=${playlistId}`;
}

function navigateToAlbumDetail(albumId) {
    window.location.href = `/whale/streaming/albumDetail?albumId=${albumId}`;
}

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

// insertTrackLike 함수를 전역으로 선언
// trackInfo 배열을 전역 변수로 설정하고 기본 초기화
let trackInfo = [];

// player_state_changed 이벤트 리스너 설정
function initializePlayer(player) {
    player.addListener('player_state_changed', (state) => {
        // 트랙 정보가 있을 때만 trackInfo 배열 초기화
        if (state && state.track_window && state.track_window.current_track) {
            trackInfo = [
                state.track_window.current_track.album.images[0].url, // 트랙 커버 이미지
                state.track_window.current_track.name,                // 트랙 이름
                state.track_window.current_track.artists[0].name,     // 아티스트 이름
                state.track_window.current_track.album.name,          // 앨범 이름
                state.track_window.current_track.id,                  // 트랙 ID
                false                                                 // 좋아요 상태 기본값
            ];

            // 비동기로 앨범 ID와 아티스트 ID를 추가로 가져옴
            (async () => {
                try {
                    const result = await fetchWebApi(`v1/tracks/${trackInfo[4]}`, 'GET');
                    trackInfo[6] = result.album.id;    // 앨범 ID
                    trackInfo[7] = result.artists[0].id;  // 아티스트 ID
                } catch (error) {
                    console.error('Error fetching track details:', error);
                }
            })();

            // 좋아요 상태를 서버에서 가져와 trackInfo[5]에 설정
            fetch(`/whale/streaming/currentTrackInfo`, {
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                method: 'POST',
                body: JSON.stringify({
                    artistName: trackInfo[2],
                    trackName: trackInfo[1],
                    albumName: trackInfo[3],
                    trackCover: trackInfo[0],
                    trackSpotifyId: trackInfo[4]
                })
            })
                .then(response => response.json())
                .then(data => {
                    trackInfo[5] = data.result === 'yes';  // 좋아요 상태를 업데이트
                })
                .catch(error => console.error('Error fetching like status:', error));
        } else {
            console.error("Player state or track information is missing.");
        }
    });
}

// 좋아요 상태 변경 함수
let likeActionPending = false; // 중복 요청 방지를 위한 상태 잠금 변수

async function insertTrackLike(coverUrl, trackName, artistName, albumName, trackId, isLiked) {
    if (likeActionPending) return;
    likeActionPending = true;

    trackInfo = [coverUrl, trackName, artistName, albumName, trackId, isLiked];

    try {
        const body = {
            artistName: trackInfo[2],
            trackName: trackInfo[1],
            albumName: trackInfo[3],
            trackCover: trackInfo[0],
            trackSpotifyId: trackInfo[4]
        };

        const response = await fetch(`/whale/streaming/toggleTrackLike`, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'POST',
            body: JSON.stringify(body)
        });

        if (response.ok) {
            const data = await response.json();
            if (data.result === 'inserted') {
                console.log("Track liked successfully.");
                trackInfo[5] = true;  // 좋아요 상태 설정
            } else if (data.result === 'deleted') {
                console.log("Track unliked successfully.");
                trackInfo[5] = false; // 좋아요 상태 해제
            }
        } else {
            console.error('Failed to update the Track Like Data:', response.statusText);
        }
    } catch (error) {
        console.error('Error while updating the Track Like Data:', error);
    } finally {
        likeActionPending = false;
    }
}

// player 초기화 함수
function setupPlayer() {
    window.onSpotifyWebPlaybackSDKReady = () => {
        const player = new Spotify.Player({
            name: 'Whale Player',
            getOAuthToken: cb => { cb(sessionStorage.accessToken); },
            volume: 0.5
        });

        // Player 연결
        player.connect().then(success => {
            if (success) {
                console.log('The Web Playback SDK successfully connected to Spotify!');
            }
        });

        // Player 이벤트 리스너 추가
        initializePlayer(player);
    };
}

// Fetch Web API 함수 예시
async function fetchWebApi(url, method) {
    const response = await fetch(`https://api.spotify.com/${url}`, {
        method: method,
        headers: {
            'Authorization': `Bearer ${sessionStorage.accessToken}`
        }
    });
    return response.json();
}

// 초기화 코드 실행
setupPlayer();
