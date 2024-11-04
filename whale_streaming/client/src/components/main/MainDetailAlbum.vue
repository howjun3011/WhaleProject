<template>
    <div class="playlistDetail">
        <div class="playlistDetailContainer" v-if="artist !== null">
            <img :src="album.images[0].url" :alt="album.name" width="230"
                        height="230" style="border-radius: 8px;">
            <div class="playlistDetailInfo">
                <p class="detailSort">{{ album.album_type }}</p>
                <p class="playlistName">{{ album.name }}</p>
                <div class="trackDescription">
                    <img :src="artist.images[0].url" :alt="album.name" width="24" height="24" style="border-radius: 50%; cursor: pointer;" @click="redirectRouter('artist',artist.id)">
                    <p class="trackFont" style="margin-left: 2px;" @click="redirectRouter('artist',artist.id)">{{ album.artists[0].name }}</p>
                    <p> • </p>
                    <p>{{ album.total_tracks }}곡</p>
                    <p> • </p>
                    <p>{{ String(Math.floor( totalTrack / (1000 * 60 ) )).padStart(2, "0") }}분 {{ String(Math.floor( ( totalTrack % (1000 * 60 )) / 1000 )).padStart(2, "0") }}초</p>
                    <p> • </p>
                    <p>{{ album.release_date }}</p>
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
                @click="playPlayer(album.uri)"
            >
                <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
                ></path>
            </svg>
        </div>
    </div>
    <div class="playlist-tracks" style="height: 25px; margin-top: 5px; pointer-events: none;">
        <div class="playlist-tracks-top" style="justify-content: center;">#</div>
        <div class="playlist-tracks-top" style="padding-left: 5px;">제목</div>
        <div class="playlist-tracks-top" style="justify-content: center;">시간</div>
    </div>
    <div v-if="artist !== null" style="width: 100%; height: 50%; margin-top: 19px;">
        <div class="playlist-tracks" style="padding: 9px 0;" v-for="(item, i) in album.tracks.items" :key="i" @mouseover="isShow[i] = true" @mouseleave="isShow[i] = false">
            <div class="playlist-tracks-content" style="justify-content: center;" v-if="!isShow[i]">{{ i+1 }}</div>
            <div class="playlist-tracks-content" style="justify-content: center;" v-if="addIsShow(i)">
                <svg
                    data-encore-id="icon"
                    role="img"
                    aria-hidden="true"
                    viewBox="0 0 24 24"
                    class="playlistTrackBtn"
                    style="height: 16px;"
                    @click="playPlayer(item.track.uri)"
                >
                    <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
                    ></path>
                </svg>
            </div>
            <div class="playlist-tracks-content" style="display: block; padding-left: 5px;">
                <p style="font-weight: 400; cursor: pointer;"  @click="redirectRouter('track',item.id)">{{ item.name }}</p>
                <p style="cursor: pointer;" @click="redirectRouter('artist',item.artists[0].id)">{{ item.artists[0].name }}</p>
            </div>
            <div class="playlist-tracks-content" style="justify-content: center; font-size: 12px;">{{ String(Math.floor(( item.duration_ms / (1000 * 60 )) )).padStart(2, "0") }}분 {{ String(Math.floor(( item.duration_ms % (1000 * 60 )) / 1000 )).padStart(2, "0") }}초</div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            artist: null,
            album: null,
            totalTrack: null,
            isShow: [],
        }
    },
    mounted() {
        this.getAlbumInfo();
        this.changeBackground();
    },
    methods: {
        async getAlbumInfo() {
            const result = await fetch(`/whale/streaming/getAlbumInfo?id=${this.$route.params.id}`);
            if (await result.ok) {
                const data = await result.json();
                this.album = await data;

                this.album.tracks.items.forEach((item) => {this.totalTrack += item.duration_ms;});
                
                fetch(`/whale/streaming/getArtistInfo?id=${this.album.artists[0].id}`)
                    .then((response) => response.json())
                    .then((data) => {
                        this.artist = data;
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
        addIsShow(i) {
            this.isShow.push(false);
            return this.isShow[i];
        },
        redirectRouter(i,y) {
            this.$router.replace(`/whale/streaming/detail/${i}/${y}`);
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
    .playlistFunction {width: 100%; margin-bottom: 20px;}
    .playlistBtnCircle {display: flex; justify-content: center; align-items: center; width: 50px; height: 50px; margin-left: 30px; border-radius: 50%; background-color: rgb(30, 214, 96);}
    .playlistBtnCircle:hover {opacity: 0.8;}
    .playlistBtnCircle:active {opacity: 0.6;}
    .playlistBtn {height: 22px;}
    .playlist-tracks {position: relative; display: grid; grid-template-columns: 6% 83% 11%; width: 95%; margin-left: 20px;}
    .playlist-tracks:hover {border-radius: 5px; background-color: #5e5e5e;}
    .playlist-tracks-top {display: flex; align-items: center; height: 25px; border-top: 0.5px solid rgb(197, 197, 197, 0.7); padding-top: 10px; padding-bottom: 6px; font-size: 13px; color: #ffffff; font-weight: 300; letter-spacing: 0.2px; opacity: 0.8;}
    .playlist-tracks-content {display: flex; align-items: center; height: 32px; color: #ffffff; font-size: 14px; font-weight: 300; letter-spacing: 0.2px; opacity: 0.8;}
    .playlistTrackBtn:hover {opacity: 0.8;}
    .playlistTrackBtn:active {opacity: 0.6;}
</style>