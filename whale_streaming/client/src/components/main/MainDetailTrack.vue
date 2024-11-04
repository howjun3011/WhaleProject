<template>
    <div class="playlistDetail">
        <div class="playlistDetailContainer" v-if="artist !== null">
            <img :src="track.album.images[0].url" :alt="track.name" width="230"
                        height="230" style="border-radius: 8px;">
            <div class="playlistDetailInfo">
                <p class="detailSort">곡</p>
                <p class="playlistName">{{ track.name }}</p>
                <div class="trackDescription">
                    <img :src="artist.images[0].url" :alt="track.name" width="24" height="24" style="border-radius: 50%; cursor: pointer;">
                    <p class="trackFont" style="margin-left: 2px;">{{ track.artists[0].name }}</p>
                    <p> • </p>
                    <p class="trackFont">{{ track.album.name }}</p>
                    <p> • </p>
                    <p>{{ track.album.release_date }}</p>
                </div>
            </div>
        </div>
    </div>
    <div class="playlistFunction">
        <div class="playlistBtnCircle">
            <svg
                data-encore-id="icon"
                role="img"
                aria-hidden="true"
                viewBox="0 0 24 24"
                class="playlistBtn"
                @click="playPlayer(track.uri)"
            >
                <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
                ></path>
            </svg>
        </div>
    </div>
    <div class="lyrics">
        <h3>가사</h3>
        <pre class="trackLyric" v-if="lyric !== null">{{ lyric }}</pre>
        <pre v-if="lyric === undefined">가사를 찾을 수 없습니다.</pre>
    </div>
</template>

<script>
export default {
    data() {
        return {
            track: null,
            artist: null,
            lyric: null,
        }
    },
    mounted() {
        this.getTrackInfo();
        this.changeBackground();
    },
    methods: {
        async getTrackInfo() {
            const result = await fetch(`/whale/streaming/getTrackInfo?id=${this.$route.params.id}`);
            if (await result.ok) {
                const data = await result.json();
                this.track = await data;
                
                fetch(`/whale/streaming/getArtistInfo?id=${this.track.artists[0].id}`)
                    .then((response) => response.json())
                    .then((data) => {
                        this.artist = data;
                    })
                    
                fetch(`https://api.lyrics.ovh/v1/${encodeURIComponent(this.track.artists[0].name)}/${encodeURIComponent(this.track.name)}`)
                    .then((response) => response.json())
                    .then((data) => {
                        this.lyric = data.lyrics;
                        console.log(this.lyric);
                    })
            } else {
                console.error('Failed to fetch user top items:', result.statusText);
            }
        },
        async playPlayer(i) {
            await fetch(`/whale/streaming/play?uri=${ i }&device_id=${ sessionStorage.device_id }`);
        },
        getRandomColor() {
            // 랜덤 RGB 색상 생성 함수
            const r = Math.floor(Math.random() * 256);
            const g = Math.floor(Math.random() * 256);
            const b = Math.floor(Math.random() * 256);
            console.log("Generated RGB values:", r, g, b);
            return `rgb(${r}, ${g}, ${b})`;
        },
        changeBackground() {
            document.querySelector('.mainContent').style.backgroundImage = `linear-gradient(${this.getRandomColor()} 10%, rgb(17, 18, 17) 90%)`;
        },
    },
};
</script>

<style scoped>
    .playlistDetail {display: flex; align-items: center; width: 95%; height: 35%; padding: 40px 0 20px 15px;}
    .playlistDetailContainer {display: flex; gap: 20px; color: white; align-items: end; width: 100%; padding-left: 20px; overflow-x: scroll; -ms-overflow-style: none;}
    .playlistDetailInfo {width: 75%; height: 170px; overflow: auto; white-space: nowrap; text-overflow: ellipsis;}
    .detailSort {margin-top: 15px; margin-left: 2px; font-size: 12px; font-weight: 300; letter-spacing: 0.3px; opacity: 0.7;}
    .trackDescription{font-size: 12px; font-weight: 300; letter-spacing: .2px; opacity: .8; display: flex; align-items: center; margin-top: 15px; gap: 5px;}
    .trackFont {font-size: 14px; font-weight: bold; cursor: pointer;}
    .playlistName {font-size: 64px; font-weight: 400; letter-spacing: 0.4px; opacity: 0.8;}
    .playlistFunction {width: 100%;}
    .playlistBtnCircle {display: flex; justify-content: center; align-items: center; width: 50px; height: 50px; margin-left: 30px; border-radius: 50%; background-color: rgb(30, 214, 96);}
    .playlistBtnCircle:hover {opacity: 0.8;}
    .playlistBtnCircle:active {opacity: 0.6;}
    .playlistBtn {height: 22px;}
    .lyrics{color: white; width: 95%; margin-top: 40px; margin-left: 20px; overflow: scroll; padding-top: 20px; padding-left: 10px; border-top: 0.5px solid rgb(197, 197, 197, 0.7);}
    .trackLyric {padding-top: 15px; line-height: 20px;}
</style>