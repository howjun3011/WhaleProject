<template>
    <div class="main">
        <MainLibrary :libraries="libraries" />
        <div class="mainContentFrame">
            <div class="mainContent">
                <div class="mainContentMargin">
                    <!-- Router View에 라이브러리 정보 전달 -->
                    <router-view
                        :key="$route.fullPath"
                        :libraries="libraries"
                        :change-background="changeBackground"
                        :play-player="playPlayer"
                        :scroll-content="scrollContent"
                        :check-scroll="checkScroll"
                        @update-library="getUserLibraries"
                    />
                </div>
            </div>
        </div>
        <div class="mainDetailFrame"></div>
    </div>
    <div class="footer"></div>
</template>

<script>
import MainLibrary from './MainLibrary.vue'

export default {
    components: {
        MainLibrary,
    },
    data() {
        return {
            libraries: null,
        };
    },
    mounted() {
        this.getUserLibraries();
    },
    methods: {
        // 라이브러리 정보를 받아 오는 함수
        async getUserLibraries() {
            const result = await fetch('/whale/streaming/getLibraries');
            if (result.ok) {
                const data = await result.json();
                if (data.items && data.items.length > 0) {
                    this.libraries = data.items;
                } else {
                    console.error('No items found');
                }
            } else {
                console.error('Failed to fetch user top items:', result.statusText);
            }
        },
        // 랜덤 RGB 색상 생성 함수
        getRandomColor() {
            const r = Math.floor(Math.random() * 256);
            const g = Math.floor(Math.random() * 256);
            const b = Math.floor(Math.random() * 256);
            console.log("Generated RGB values:", r, g, b);
            return `rgb(${r}, ${g}, ${b})`;
        },
        // 배경색 변화 함수
        changeBackground() {
            if (localStorage.getItem('darkmodeOn') === "1") {document.querySelector('.mainContent').style.backgroundImage = `linear-gradient(${this.getRandomColor()} 0%, rgb(17, 18, 17) 100%)`;}
            else {document.querySelector('.mainContent').style.backgroundImage = `linear-gradient(${this.getRandomColor()} 0%, rgb(249, 250, 249) 100%)`;}
        },
        // 재생 함수
        async playPlayer(i) {
            await fetch(`/whale/streaming/play?uri=${ i }&device_id=${ sessionStorage.device_id }`);
        },
        // 스크롤 버튼을 위한 함수
        updateScrollButtons(containerSelector) {
            const container = document.querySelector(containerSelector);
            if (!container) return;

            const scrollLeftBtn = container.parentNode.querySelector('.artistDetailSlideButton.left');
            const scrollRightBtn = container.parentNode.querySelector('.artistDetailSlideButton.right');

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
        },
        scrollContent(containerSelector, direction) {
            const container = document.querySelector(containerSelector);
            if (!container) return;
            
            const scrollAmount = direction === 'left' ? -210 : 210;
            container.scrollBy({ left: scrollAmount, behavior: 'smooth' });

            setTimeout(() => {
                this.updateScrollButtons(containerSelector);
            }, 300);
        },
        checkScroll(containerSelector) {
            const container = document.querySelector(containerSelector);
            if (container) {
                this.updateScrollButtons(containerSelector);
                container.addEventListener('scroll', () => this.updateScrollButtons(containerSelector));
            }
        },
    },
};
</script>

<style scoped>
    .main {display: flex; width: 100%; background-color: #1f1f1f;}
    #app.light .main {background-color: #f0f0f0;}
    .footer {width: 100%; height: 10px; background-color: #1f1f1f;}
    #app.light .footer {background-color: #eeeeee;}
    .mainContentFrame {display: flex; justify-content: center; align-items: center; min-width: 200px; height: 100%;}
    .mainContent {width: 100%; height: 96%; background-color: #2e2e2e; border-radius: 16px; overflow: auto; -ms-overflow-style: none;}
    #app.light .mainContent {background-color: #fff; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);}
    .mainContentMargin {margin: 0 10px 0 10px; width: 96%; height: 100%;}
    #app.light .mainContentMargin {color: #111;}
    .mainDetailFrame {display: flex; justify-content: center; align-items: center; width: 2%; height: 100%;}
</style>