// [ Resize ]
$(document).ready(() => {resize();});
$(window).resize(() => {resize();});

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
    if (event.data === 'Full') {console.log(event.data);}
    else {await sendDeviceId(event);}
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
    fetch('/whale/streaming/playTrack', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ trackId: trackId })
    })
        .then(response => {
            if (response.ok) {
                console.log("Track is now playing");
            } else {
                console.error("Failed to play track");
            }
        })
        .catch(error => console.error("Error playing track:", error));
}

$(document).ready(function() {
    var isExpanded = false;

    $('#toggleButton').click(function() {
        isExpanded = !isExpanded; // 상태를 토글
        $('.mainLibraryFrame, .mainLibrary').toggleClass('expanded', isExpanded); // 두 요소에 클래스 추가/제거
    });
});
