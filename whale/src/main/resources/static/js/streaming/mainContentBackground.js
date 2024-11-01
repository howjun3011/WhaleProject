document.addEventListener('DOMContentLoaded', function () {
    // 랜덤 RGB 색상 생성 함수
    function getRandomColor() {
        const r = Math.floor(Math.random() * 256);
        const g = Math.floor(Math.random() * 256);
        const b = Math.floor(Math.random() * 256);
        console.log("Generated RGB values:", r, g, b);
        return `rgb(${r}, ${g}, ${b})`;
    }

    // mainContent 요소를 찾고 배경색을 변경
    const mainContent = document.querySelector('.mainContent');
    if (mainContent) {
        const randomColor = getRandomColor(); // 여기서 랜덤 색상 생성
        console.log("Random color:", randomColor);
        mainContent.style.backgroundImage = `linear-gradient(${randomColor}, rgb(17, 18, 17))`;
        console.log("Background image:", mainContent.style.backgroundImage);
    } else {
        console.error('mainContent 요소를 찾을 수 없습니다.');
    }
});