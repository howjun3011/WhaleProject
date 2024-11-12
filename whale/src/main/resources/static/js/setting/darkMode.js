document.addEventListener("DOMContentLoaded", function () {
    const settingElement = document.querySelector('.setting-body');
    const feedElement = document.querySelector('.feed-container');
    const toggleSlide = document.getElementById('toggle-slide');

    // 페이지 로드 시 localStorage에서 darkmodeOn 값을 가져와 data-darkmode 설정
    let darkmodeOn = localStorage.getItem('darkmodeOn') || "0";

    // 설정 페이지에서 실행될 경우 settingElement 사용
    if (settingElement) {
        settingElement.setAttribute("data-darkmode", darkmodeOn);
        const isDarkMode = darkmodeOn === "1";
        toggleSlide.checked = isDarkMode;
        settingElement.classList.toggle("dark", isDarkMode);
        settingElement.classList.toggle("light", !isDarkMode);

        // 토글 버튼 변경 시 다크 모드 설정 및 저장
        toggleSlide.addEventListener('change', function () {
            darkmodeOn = this.checked ? "1" : "0";

            // 다크 모드 상태를 localStorage와 data-darkmode 속성에 저장
            localStorage.setItem('darkmodeOn', darkmodeOn);
            settingElement.setAttribute("data-darkmode", darkmodeOn);
            settingElement.classList.toggle("dark", darkmodeOn === "1");
            settingElement.classList.toggle("light", darkmodeOn !== "1");

            // feedHome 페이지에 다크모드 변경 사항 전달
            window.parent.postMessage({ darkmodeOn: darkmodeOn }, "*");

            // AJAX 요청
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/whale/updateDarkmode', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send('darkmode_setting_onoff=' + darkmodeOn);
        });
    }

    // feedHome 페이지에서 실행될 경우 feedElement 사용
    if (feedElement) {
        feedElement.setAttribute("data-darkmode", darkmodeOn);
        const isDarkMode = darkmodeOn === "1";
        feedElement.classList.toggle("dark", isDarkMode);
        feedElement.classList.toggle("light", !isDarkMode);

        // 설정 페이지에서 postMessage 이벤트로 다크 모드 변경 사항을 수신
        window.addEventListener('message', function (event) {
            if (event.data && event.data.darkmodeOn !== undefined) {
                darkmodeOn = event.data.darkmodeOn;
                feedElement.setAttribute("data-darkmode", darkmodeOn);

                const isDarkMode = darkmodeOn === "1";
                feedElement.classList.toggle("dark", isDarkMode);
                feedElement.classList.toggle("light", !isDarkMode);
            }
        });
    }

    // 다른 탭에서 localStorage 값이 변경될 때 적용
    window.addEventListener('storage', function (event) {
        if (event.key === 'darkmodeOn') {
            darkmodeOn = event.newValue || "0";

            // 설정 페이지에서 data-darkmode 속성 업데이트
            if (settingElement) {
                settingElement.setAttribute("data-darkmode", darkmodeOn);
                const isDark = darkmodeOn === "1";
                settingElement.classList.toggle("dark", isDark);
                settingElement.classList.toggle("light", !isDark);
                toggleSlide.checked = isDark;
            }

            // feedHome 페이지에서 data-darkmode 속성 업데이트
            if (feedElement) {
                feedElement.setAttribute("data-darkmode", darkmodeOn);
                const isDark = darkmodeOn === "1";
                feedElement.classList.toggle("dark", isDark);
                feedElement.classList.toggle("light", !isDark);
            }
        }
    });
});
