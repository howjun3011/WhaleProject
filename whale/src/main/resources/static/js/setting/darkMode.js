document.addEventListener("DOMContentLoaded", function () {
    const settingElement = document.querySelector('.setting-body');
    const feedElement = document.querySelector('.feed-container');
    const communityElement = document.querySelector('.container');
    const toggleSlide = document.getElementById('toggle-slide');
    let darkmodeOn = localStorage.getItem('darkmodeOn') || "0";

    const updateScrollbarStyle = () => {
        const styleSheet = document.getElementById("darkmode-scrollbar-styles");
        if (darkmodeOn === "1") {
            styleSheet.innerHTML = `
                html::-webkit-scrollbar {display: block; width: 8px;}
                html::-webkit-scrollbar-track {background: #2e2e2e;}
                html::-webkit-scrollbar-thumb {background-color: #555; border-radius: 4px;}
                html {width: 100%; height: 190px; overflow-y: auto; scroll-behavior: smooth; display: flex; flex-direction: column;}
            `;
        } else {
            styleSheet.innerHTML = `
                html::-webkit-scrollbar {display: block; width: 8px;}
                html::-webkit-scrollbar-track {background: #fff;}
                html::-webkit-scrollbar-thumb {background-color: #ccc; border-radius: 4px;}
                html {width: 100%; height: 190px; overflow-y: auto; scroll-behavior: smooth; display: flex; flex-direction: column;}
            `;
        }
    };

    if (settingElement) {
        settingElement.setAttribute("data-darkmode", darkmodeOn);
        const isDarkMode = darkmodeOn === "1";
        toggleSlide.checked = isDarkMode;
        settingElement.classList.toggle("dark", isDarkMode);
        settingElement.classList.toggle("light", !isDarkMode);

        toggleSlide.addEventListener('change', function () {
            darkmodeOn = this.checked ? "1" : "0";
            localStorage.setItem('darkmodeOn', darkmodeOn);
            settingElement.setAttribute("data-darkmode", darkmodeOn);
            settingElement.classList.toggle("dark", darkmodeOn === "1");
            settingElement.classList.toggle("light", darkmodeOn !== "1");
            window.parent.postMessage({ darkmodeOn: darkmodeOn }, "*");

            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/whale/updateDarkmode', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send('darkmode_setting_onoff=' + darkmodeOn);
        });
    }

    if (feedElement) {
        feedElement.setAttribute("data-darkmode", darkmodeOn);
        const isDarkMode = darkmodeOn === "1";
        feedElement.classList.toggle("dark", isDarkMode);
        feedElement.classList.toggle("light", !isDarkMode);

        window.addEventListener('message', function (event) {
            if (event.data && event.data.darkmodeOn !== undefined) {
                darkmodeOn = event.data.darkmodeOn;
                feedElement.setAttribute("data-darkmode", darkmodeOn);
                const isDarkMode = darkmodeOn === "1";
                feedElement.classList.toggle("dark", isDarkMode);
                feedElement.classList.toggle("light", !isDarkMode);

                updateScrollbarStyle(); // 스크롤바 스타일 업데이트
            }
        });
    }

    if (communityElement) {
        communityElement.setAttribute("data-darkmode", darkmodeOn);
        const isDarkMode = darkmodeOn === "1";
        communityElement.classList.toggle("dark", isDarkMode);
        communityElement.classList.toggle("light", !isDarkMode);

        window.addEventListener('message', function (event) {
            if (event.data && event.data.darkmodeOn !== undefined) {
                darkmodeOn = event.data.darkmodeOn;
                communityElement.setAttribute("data-darkmode", darkmodeOn);
                const isDarkMode = darkmodeOn === "1";
                communityElement.classList.toggle("dark", isDarkMode);
                communityElement.classList.toggle("light", !isDarkMode);

                updateScrollbarStyle(); // 스크롤바 스타일 업데이트
            }
        });
    }

    window.addEventListener('storage', function (event) {
        if (event.key === 'darkmodeOn') {
            darkmodeOn = event.newValue || "0";
            if (settingElement) {
                settingElement.setAttribute("data-darkmode", darkmodeOn);
                const isDark = darkmodeOn === "1";
                settingElement.classList.toggle("dark", isDark);
                settingElement.classList.toggle("light", !isDark);
                toggleSlide.checked = isDark;
            }
            if (feedElement) {
                feedElement.setAttribute("data-darkmode", darkmodeOn);
                const isDark = darkmodeOn === "1";
                feedElement.classList.toggle("dark", isDark);
                feedElement.classList.toggle("light", !isDark);
            }
            if (communityElement) {
                communityElement.setAttribute("data-darkmode", darkmodeOn);
                const isDark = darkmodeOn === "1";
                communityElement.classList.toggle("dark", isDark);
                communityElement.classList.toggle("light", !isDark);
            }
            updateScrollbarStyle(); // 스크롤바 스타일 업데이트
        }
    });

    // 초기 페이지 로드 시 스크롤바 스타일 적용
    updateScrollbarStyle();
});
