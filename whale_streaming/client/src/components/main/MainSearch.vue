<template>
    <div class="recommendationsHeader"></div>
    <div class="recommendations" v-if="search !== null">
        <!-- 왼쪽 버튼 -->
        <button class="artistDetailSlideButton left" id="scrollLeftBtn" @click="scrollLeftContent()">
            <img src="../../../public/images/main/prev.png"
                    alt="Left Button" width="30"
                    height="30" style="border-radius: 8px; opacity: 0.75;">
        </button>
        <div class="recommendationTitle"><p class="titleName">곡</p></div>
        <div class="recommendationContents">
            <div class="recommendationContent" v-for="(item, i) in search.tracks.items" :key="i" @mouseover="isShow[i] = true" @mouseleave="isShow[i] = false">
                <div class="recommendationLike" style="left: 15px;" v-if="addIsShow(i)">
                    <img src="../../../public/images/main/like.png" alt="Like Button" width="30" height="30" style="border-radius: 8px; opacity: 0.75;">
                </div>
                <div class="recommendationCover">
                    <img :src="item.album.images[0].url" :alt="item.name" width="120" height="120" style="border-radius: 8px; cursor: pointer;" @click="redirectRouter('track',item.id)">
                </div>
                <div class="recommendationLike" style="right: 15px;" v-if="addIsShow(i)" @click="playPlayer(item.uri)">
                    <img src="../../../public/images/main/play.png"
                            alt="Play Button" width="30"
                            height="30" style="border-radius: 8px; opacity: 0.75;">
                </div>
                <div class="recommendationInfo">
                    <p class="trackName" style="cursor: pointer;" @click="redirectRouter('track',item.id)">{{ item.name }}</p>
                    <p class="artistName" style="cursor: pointer;" @click="redirectRouter('artist',item.artists[0].id)">{{ item.artists[0].name }}</p>
                </div>
            </div>
        </div>
        <!-- 오른쪽 버튼 -->
        <button class="artistDetailSlideButton right" id="scrollRightBtn" @click="scrollRightContent()">
            <img src="../../../public/images/main/next.png"
                    alt="Right Button" width="30"
                    height="30" style="border-radius: 8px; opacity: 0.75;">
        </button>
    </div>
</template>

<script>
export default {
    data() {
        return {
            search: null,
            isShow: [],
        }
    },
    mounted() {
        this.getSearch();
    },
    methods: {
        async getSearch() {
            const result = await fetch(`/whale/streaming/getArtistPlaylist?q=${this.$route.params.query}&t=track`);
            if (await result.ok) {
                const data = await result.json();
                this.search = await data;
                this.$nextTick(() => {
                    this.checkScroll();
                });
            } else {
                console.error('Failed to fetch user search items:', result.statusText);
            }
        },
        addIsShow(i) {
            this.isShow.push(false);
            return this.isShow[i];
        },
        async playPlayer(i) {
            await fetch(`/whale/streaming/play?uri=${ i }&device_id=${ sessionStorage.device_id }`);
        },
        updateScrollButtons() {
            const container = document.querySelector('.recommendationContents');
            const scrollLeftBtn = document.getElementById('scrollLeftBtn');
            const scrollRightBtn = document.getElementById('scrollRightBtn');

            if (container) {
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
        },
        scrollLeftContent() {
            const container = document.querySelector('.recommendationContents');
            container.scrollBy({ left: -210, behavior: 'smooth' });
            setTimeout(this.updateScrollButtons, 300); // 스크롤 후 버튼 업데이트
        },
        scrollRightContent() {
            const container = document.querySelector('.recommendationContents');
            container.scrollBy({ left: 210, behavior: 'smooth' });
            setTimeout(this.updateScrollButtons, 300); // 스크롤 후 버튼 업데이트
        },
        checkScroll() {
            this.updateScrollButtons();
            const container = document.querySelector('.recommendationContents');
            if (container) {
                container.addEventListener('scroll', this.updateScrollButtons); // 스크롤 이벤트 감지
            }
        },
        redirectRouter(i,y) {
            this.$router.replace(`/whale/streaming/detail/${i}/${y}`);
        },
    },
};
</script>

<style scoped>
    .recommendationsHeader {width: 100%; height: 30px;}
    .recommendations {position: relative; width: 100%; height: 240px;}
    .recommendationTitle {display: flex; flex-direction: column-reverse; width: 100%; height: 45px; padding-left: 10px; color: #F2F2F2; font-size: 17px; font-weight: 400; letter-spacing: 0.2px; opacity: 0.8;}
    .recommendationContents {display: flex; width: 100%; height: 195px; overflow: auto; -ms-overflow-style: none;}
    .recommendationContent {position: relative; flex: 0 0 auto; width: 150px; height: 100%; border-radius: 15px; opacity: 0.9;}
    .recommendationContent:hover {background-color: rgba(60,60,60,0.8);}
    .recommendationLike{position: absolute; width: 30px; height: 30px; top: 100px; background: transparent;}
    .recommendationLike:hover{opacity: 0.7;}
    .recommendationLike:active{opacity: 0.6;}
    .recommendationCover {display: flex; justify-content: center; align-items: center; width: 100%; height: 155px;}
    .recommendationInfo {width: 100%; height: 40px; padding: 0 12px; color: #FFFFFF;}
    .trackName {font-size: 12px; font-weight: 400; letter-spacing: 0.4px; opacity: 0.8;}
    .artistName {font-size: 11px; font-weight: 200; letter-spacing: 0.4px; opacity: 0.8;}
    .artistDetailSlideButton {cursor: pointer; position: absolute; z-index: 1; transition: opacity 0.3s ease; border: 0; background-color: transparent; transform: translateY(-50%);}
    .artistDetailSlideButton.left {left: 0; top: 50%;}
    .artistDetailSlideButton.right {right: 0; top: 50%;}
    .artistDetailSlideButton.hidden {opacity: 0; pointer-events: none; /* 클릭 불가 */}
</style>