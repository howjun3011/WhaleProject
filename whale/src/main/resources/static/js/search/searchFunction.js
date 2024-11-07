// [ Resize ]
$(document).ready(() => {
    resize();
});
$(window).resize(() => {
    resize();
});

function resize() {
    const headerElement = document.querySelector(".headerSearch");
    const mainElement = document.querySelector(".mainSearch");

    const windowHeight = window.innerHeight;
    const headerHeight = headerElement ? headerElement.offsetHeight : 0;

    if (mainElement) {
        mainElement.style.height = `${windowHeight - headerHeight}px`;
    }
}